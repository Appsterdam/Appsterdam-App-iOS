//
//  Model.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 01/02/2022.
//

import Foundation
import Combine
import OSLog

/// Model class for decoding JSON files
///
/// usage:
///
///     // Load as [Codable]?
///     Model<Codable>("https://server/file.ext").Model
///
///     // Only update and cache (never run this, unless it's for background updates)
///     Model<Codable>("https://server/file.ext").update()
class Model<T: Codable>: ObservableObject {
    /// Model
    @Published public var model: T?

    /// The url to fetch the model from
    private let webURL: URL

    /// The url of the cache (automatic generated)
    private let cache: URL

    /// Cache lifetime in seconds
    private let maxAge: Double = 3600 * 24 * 7 // Keep one week.

    /// Are we debugging?
    private let debug: Bool = true

    /// Logger
    private let logger = Logger(subsystem: "rs.appsterdam", category: "Model")

    /// Initialize Model
    /// - Parameter url: URL
    init(url: String) {
        logger.debug("Model V2 For <\(T.self)> Initialized.")
        guard let url = URL(string: url) else {
            logger.debug("Invalid url(\"\(url)\") provided <\(T.self)>.")
            fatalError("Invalid url(\"\(url)\") provided <\(T.self)>.")
        }

        webURL = url

        cache = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(url.lastPathComponent)

        Task { @MainActor in
            model = await load()
            self.objectWillChange.send()
        }
    }

    /// Load model from internet/cache
    /// - Returns: `T?`
    private func load() async -> T? {
        // Check, if we have at least 1 person
        guard let events = loadFromCache() else {
            guard let fetchedEvents = await update() else {
                // Try one more time with the 'old' cache.
                guard let events = loadFromCache(ignoreCacheTime: true) else {
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

    /// Is the cache valid?
    /// - Parameter ignoreCacheTime: Ignore the maximum cache time
    /// - Returns: boolean wherever the cache is still valid or not
    private func isCacheValid(ignoreCacheTime: Bool = false) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: cache.path) {
                let attributes = try FileManager.default.attributesOfItem(atPath: cache.path)

                if ignoreCacheTime {
                    return true
                }

                if let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date,
                   Date().timeIntervalSince1970 < modificationDate.timeIntervalSince1970 + maxAge {
                    return true
                }
            }
        } catch {
            if debug {
                logger.debug("\(self.cache.path) is invalid")
            }
            logger.error("Error: \(error)")
        }

        return false
    }

    /// Load Model from cache
    /// - Returns: `Model<T>?`
    private func loadFromCache(ignoreCacheTime: Bool = false) -> T? {
        do {
            if isCacheValid(ignoreCacheTime: ignoreCacheTime) {
                let jsonData = try Data.init(contentsOf: cache)
                if debug {
                    logger
                        .debug("Loading <\(T.self)> \(self.cache.path) from cache.")
                }
                return parse(json: jsonData)
            }
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
            let jsonData = try Data.init(contentsOf: webURL)
            if debug {
                logger.debug("Saving <\(T.self)> to \(self.cache.path)")
            }
            try? jsonData.write(to: cache)

            let updatedModel = parse(json: jsonData)

            Task { @MainActor in
                // Send notification to publisher that the value is updated
                self.model = updatedModel
                self.objectWillChange.send()
            }

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
