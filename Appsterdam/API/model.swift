//
//  Model.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 01/02/2022.
//

import Foundation
import Combine
import OSLog

private actor ModelCache {
    func data(at url: URL, maxAge: TimeInterval, ignoreAge: Bool) throws -> Data? {
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
    }

    func write(_ data: Data, to url: URL) throws {
        try data.write(to: url, options: .atomic)
    }
}

/// Model class for decoding JSON files
///
/// usage:
///
///     // Load as [Codable]?
///     Model<Codable>("https://server/file.ext").Model
///
///     // Only update and cache (never run this, unless it's for background updates)
///     Model<Codable>("https://server/file.ext").update()
@MainActor
final class Model<T: Codable>: ObservableObject {
    /// Model
    @Published public var model: T?

    /// The url to fetch the model from
    private let webURL: URL

    /// The url of the cache (automatic generated)
    private let cache: URL
    private let cacheStore = ModelCache()

    /// Cache lifetime in seconds
    private let maxAge: Double = 3600 * 24 * 7 // Keep one week.

    /// Are we debugging?
    private let debug: Bool = true

    /// Logger
    private let logger = Logger(subsystem: "rs.appsterdam", category: "Model")

    /// Initialize Model
    /// - Parameters:
    ///   - url: URL
    ///   - automaticallyLoads: Whether to load cached and remote data immediately.
    init(url: String, automaticallyLoads: Bool = true) {
        logger.debug("Model V2 For <\(T.self)> Initialized.")
        guard let url = URL(string: url) else {
            logger.debug("Invalid url(\"\(url)\") provided <\(T.self)>.")
            fatalError("Invalid url(\"\(url)\") provided <\(T.self)>.")
        }

        webURL = url

        cache = URL.documentsDirectory.appending(path: url.lastPathComponent)

        if automaticallyLoads {
            Task {
                model = await load()
            }
        }
    }

    /// Load model from internet/cache
    /// - Returns: `T?`
    private func load() async -> T? {
        // Check, if we have at least 1 person
        guard let events = await loadFromCache() else {
            guard let fetchedEvents = await update() else {
                // Try one more time with the 'old' cache.
                guard let events = await loadFromCache(ignoreCacheTime: true) else {
                    logger.error("We can't load data from disk or internet.\nCannot create: \(T.self)")
                    return nil
                }

                // Return the 'old' cache.
                return events
            }

            // Return list from web
            return fetchedEvents
        }

        // Reload (in background) after 5 seconds using Swift Concurrency.
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(5))
            guard let self else { return }
            await self.update()
        }

        // Return T list.
        return events
    }

    /// Load Model from cache
    /// - Returns: `Model<T>?`
    private func loadFromCache(ignoreCacheTime: Bool = false) async -> T? {
        do {
            guard let jsonData = try await cacheStore.data(
                at: cache,
                maxAge: maxAge,
                ignoreAge: ignoreCacheTime
            ) else {
                return nil
            }

            if debug {
                logger.debug("Loading <\(T.self)> \(self.cache.path) from cache.")
            }
            return parse(json: jsonData)
        } catch {
            if debug {
                logger.debug("Failed to load <\(T.self)> \(self.cache.path) from cache")
            }
            logger.error("Error: \(error)")
        }

        return nil
    }

    /// Update Model from internet
    /// - Returns: `Model<T>?`
    @discardableResult public func update() async -> T? {
        do {
            if debug {
                logger.debug("Loading <\(T.self)> from internet \(self.webURL.absoluteString)")
            }
            let (jsonData, response) = try await URLSession.shared.data(from: webURL)
            guard let response = response as? HTTPURLResponse,
                  200..<300 ~= response.statusCode else {
                logger.error("Invalid response while loading <\(T.self)> from \(self.webURL.absoluteString)")
                return nil
            }
            if debug {
                logger.debug("Saving <\(T.self)> to \(self.cache.path)")
            }
            try? await cacheStore.write(jsonData, to: cache)

            let updatedModel = parse(json: jsonData)
            model = updatedModel

            return updatedModel
        } catch {
            if debug {
                logger.debug("Failed to load <\(T.self)> from internet \(self.webURL.path)")
            }
            logger.error("Error: \(error)")
        }

        return nil
    }

    /// Parse data as `Model<T>?`
    /// - Parameter json: JSON (as `Data`)
    /// - Returns: `Model<T>?`
    private func parse(json: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: json)
        } catch {
            logger.error("Error: \(error)")
            logger.debug("Failed to decode <\(T.self)>")
            return nil
        }
    }

    deinit {
        if debug {
            logger.debug("Unloaded <\(T.self)>")
        }
    }
}
