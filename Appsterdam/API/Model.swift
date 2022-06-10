//
//  Model.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 01/02/2022.
//

import Foundation
import Aurora
import Combine

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
    @Published public var Model: [T]?

    /// The url to fetch the model from
    private let webURL: URL

    /// The url of the cache (automatic generated)
    private let cache: URL

    /// Cache lifetime in seconds
    private let maxAge: Double = 3600 * 24 * 7 // Keep one week.

    /// Are we debugging?
    private let debug: Bool = true

    /// Initialize Model
    /// - Parameter url: URL
    init(url: String) {
        print("Model V2 For <\(T.self)> Initialized.")
        guard let url = URL(string: url) else {
            Aurora.shared.log("Invalid url(\"\(url)\") provided <\(T.self)>.")
            fatalError("Invalid url(\"\(url)\") provided <\(T.self)>.")
        }

        webURL = url

        cache = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent(url.lastPathComponent)

        Model = load()
    }

    /// Load model from internet/cache
    /// - Returns: `[T]?`
    private func load() -> [T]? {
        // Check, if we have at least 1 person
        guard let events = loadFromCache() else {
            guard let fetchedEvents = update() else {
                // Try one more time with the 'old' cache.
                guard let events = loadFromCache(ignoreCacheTime: true) else {
                    Aurora.shared.log("We can't load data from disk or internet.\nCannot create: \(T.self)")
                    return nil
                }

                // Return the 'old' cache.
                return events
            }

            // Return list from web
            return fetchedEvents
        }

        // Reload (in background) after 5 seconds.
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5) {
            self.update()
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
                   Date().unixTime < modificationDate.unixTime + maxAge {
                    return true
                }
            }
        }
        catch {
            if debug {
                Aurora.shared.log("\(cache.path) is invalid")
            }
            Aurora.shared.log("Error: \(error)")
        }

        return false
    }

    /// Load Model from cache
    /// - Returns: `Model<T>?`
    private func loadFromCache(ignoreCacheTime: Bool = false) -> [T]? {
        do {
            if isCacheValid(ignoreCacheTime: ignoreCacheTime) {
                let jsonData = try Data.init(contentsOf: cache)
                if debug {
                    Aurora.shared.log("Loading <\(T.self)> \(cache.path) from cache.")
                }
                return parse(json: jsonData)
            }
        } catch {
            if debug {
                Aurora.shared.log("Failed to load <\(T.self)> \(cache.path) from cache")
            }
            Aurora.shared.log("Error: \(error)")
        }

        return nil
    }

    /// Update Model from internet
    /// - Returns: `Model<T>?`
    @discardableResult public func update() -> [T]? {
        do {
            if debug {
                Aurora.shared.log("Loading <\(T.self)> from internet \(webURL.absoluteString)")
            }
            let jsonData = try Data.init(contentsOf: webURL)
            if debug {
                Aurora.shared.log("Saving <\(T.self)> to \(cache.path)")
            }
            try? jsonData.write(to: cache)

            let updatedModel = parse(json: jsonData)

            DispatchQueue.main.async {
                // Send notification to publisher that the value is updated
                self.Model = updatedModel
                self.objectWillChange.send()
            }

            return updatedModel
        } catch {
            if debug {
                Aurora.shared.log("Failed to load <\(T.self)> from internet \(webURL.path)")
            }
            Aurora.shared.log("Error: \(error)")
        }

        return nil
    }

    /// Parse data as `Model<T>?`
    /// - Parameter json: JSON (as `Data`)
    /// - Returns: `Model<T>?`
    private func parse(json: Data) -> [T]? {
        do {
            return try JSONDecoder().decode([T].self, from: json)
        } catch {
            do {
                return [try JSONDecoder().decode(T.self, from: json)]
            } catch {
                Aurora.shared.log("Error: \(error)")
                Aurora.shared.log("Failed to decode <\(T.self)>")
                return nil
            }
        }
    }

    deinit {
        if debug {
            Aurora.shared.log("Unloaded <\(T.self)>")
        }
    }
}
