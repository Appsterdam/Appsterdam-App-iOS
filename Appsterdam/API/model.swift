//
//  Model.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 01/02/2022.
//

import Foundation
import Combine
import OSLog
import SwiftUI

/// Loads a remote model and owns it for the lifetime of a SwiftUI view.
///
/// Collection values start empty while their cached or remote value is loading:
///
///     @Model("https://server/file.json")
///     private var items: [Item]
///
/// Access the loader through the projected value to inspect loading state or refresh:
///
///     if $items.model == nil { ProgressView() }
///     await $items.update()
@propertyWrapper
@MainActor
struct Model<Value: Codable>: DynamicProperty {
    @StateObject private var storage: Storage
    private let defaultValue: Value

    var wrappedValue: Value {
        storage.model ?? defaultValue
    }

    var projectedValue: Self {
        self
    }

    var model: Value? {
        storage.model
    }

    init(_ url: String, defaultValue: Value) {
        _storage = StateObject(wrappedValue: Storage(url: url))
        self.defaultValue = defaultValue
    }

    @discardableResult
    func update() async -> Value? {
        await storage.update()
    }

    static func refresh(from url: String) async -> Value? {
        await Storage(url: url, automaticallyLoads: false).update()
    }

    nonisolated static func request(for url: URL) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        return request
    }

    @MainActor
    private final class Cache {
        func data(at url: URL, maxAge: TimeInterval, ignoreAge: Bool) async throws -> Data? {
            try await Task.detached(priority: .utility) {
                guard FileManager.default.fileExists(atPath: url.path) else {
                    return nil
                }

                if !ignoreAge {
                    let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
                    guard let modificationDate = attributes[.modificationDate] as? Date,
                          Date.now.timeIntervalSince(modificationDate) < maxAge else {
                        return nil
                    }
                }

                return try Data(contentsOf: url)
            }.value
        }

        func write(_ data: Data, to url: URL) async throws {
            try await Task.detached(priority: .utility) {
                try data.write(to: url, options: .atomic)
            }.value
        }
    }

    @MainActor
    private final class Storage: ObservableObject {
        @Published var model: Value?

        private let webURL: URL
        private let cache: URL
        private let cacheStore = Cache()
        private let maxAge: Double = 3600 * 24 * 7
        private let debug = true
        private let logger = Logger(subsystem: "rs.appsterdam", category: "Model")

        init(url: String, automaticallyLoads: Bool = true) {
            logger.debug("Model V2 For <\(Value.self)> Initialized.")
            guard let url = URL(string: url) else {
                logger.debug("Invalid url(\"\(url)\") provided <\(Value.self)>.")
                fatalError("Invalid url(\"\(url)\") provided <\(Value.self)>.")
            }

            webURL = url

            let documentsDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first ?? FileManager.default.temporaryDirectory
            cache = documentsDirectory.appendingPathComponent(url.lastPathComponent)

            if automaticallyLoads {
                Task {
                    model = await load()
                }
            }
        }

        private func load() async -> Value? {
            guard let cachedValue = await loadFromCache() else {
                guard let fetchedValue = await update() else {
                    guard let staleValue = await loadFromCache(ignoreCacheTime: true) else {
                        logger.error("We can't load data from disk or internet.\nCannot create: \(Value.self)")
                        return nil
                    }

                    return staleValue
                }

                return fetchedValue
            }

            Task { [weak self] in
                await self?.update()
            }

            return cachedValue
        }

        private func loadFromCache(ignoreCacheTime: Bool = false) async -> Value? {
            do {
                guard let jsonData = try await cacheStore.data(
                    at: cache,
                    maxAge: maxAge,
                    ignoreAge: ignoreCacheTime
                ) else {
                    return nil
                }

                if debug {
                    logger.debug("Loading <\(Value.self)> \(self.cache.path) from cache.")
                }
                return parse(json: jsonData)
            } catch {
                if debug {
                    logger.debug("Failed to load <\(Value.self)> \(self.cache.path) from cache")
                }
                logger.error("Error: \(error)")
                return nil
            }
        }

        @discardableResult
        func update() async -> Value? {
            do {
                if debug {
                    logger.debug("Loading <\(Value.self)> from internet \(self.webURL.absoluteString)")
                }
                let request = Model.request(for: webURL)
                let (jsonData, response) = try await URLSession.shared.data(for: request)
                guard let response = response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    logger.error("Invalid response while loading <\(Value.self)> from \(self.webURL.absoluteString)")
                    return nil
                }
                if debug {
                    logger.debug("Saving <\(Value.self)> to \(self.cache.path)")
                }
                try? await cacheStore.write(jsonData, to: cache)

                let updatedModel = parse(json: jsonData)
                model = updatedModel
                return updatedModel
            } catch {
                if debug {
                    logger.debug("Failed to load <\(Value.self)> from internet \(self.webURL.path)")
                }
                logger.error("Error: \(error)")
                return nil
            }
        }

        private func parse(json: Data) -> Value? {
            do {
                return try JSONDecoder().decode(Value.self, from: json)
            } catch {
                logger.error("Error: \(error)")
                logger.debug("Failed to decode <\(Value.self)>")
                return nil
            }
        }

        deinit {
            if debug {
                logger.debug("Unloaded <\(Value.self)>")
            }
        }
    }
}

extension Model where Value: RangeReplaceableCollection {
    init(_ url: String) {
        self.init(url, defaultValue: Value())
    }
}

extension Model where Value: ExpressibleByNilLiteral {
    init(_ url: String) {
        self.init(url, defaultValue: nil)
    }
}
