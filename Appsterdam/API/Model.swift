//
//  Model.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 01/02/2022.
//

import Foundation
import Aurora

/// Model class for decoding JSON files
///
/// usage:
///
///     Model<Codable>("https://server/file.ext").load()
class Model<T: Codable> {
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
        guard let url = URL(string: url) else {
            Aurora.shared.log("Invalid url provided <\(T.self)>.")
            fatalError()
        }
        webURL = url

        cache = FileManager.default.urls(
            for: .documentDirectory,
               in: .userDomainMask
        )[0].appendingPathComponent(url.lastPathComponent)
    }

    /// Load model from internet/cache
    /// - Returns: `Model<T>`
    func load() -> [T] {
        // Reload (in background) after 10 seconds.
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 10) {
            self.loadFromInternet()
        }

        // Check, if we have at least 1 person
        guard let events = loadFromCache() else {
            guard let fetchedEvents = loadFromInternet() else {
                Aurora.shared.log("This should never happen, something is corrupt.\nCannot create: \(T.self)")
                fatalError()
            }

            // Return list from web
            return fetchedEvents
        }

        // Return team list.
        return events
    }

    /// Is the cache valid?
    /// - Returns: boolean wherever the cache is still valid or not
    private func isCacheValid() -> Bool {
        do {
            if FileManager.default.fileExists(atPath: cache.path) {
                let attributes = try FileManager.default.attributesOfItem(atPath: cache.path)

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
    private func loadFromCache() -> [T]? {
        do {
            if isCacheValid() {
                let jsonData = try Data.init(contentsOf: cache)
                if debug {
                    Aurora.shared.log("Loading <\(T.self)> \(cache.path) from cache")
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


    /// Load Model from internet
    /// - Returns: `Model<T>?`
    @discardableResult private func loadFromInternet() -> [T]? {
        do {
            if debug {
                Aurora.shared.log("Loading <\(T.self)> from internet \(webURL.absoluteString)")
            }
            let jsonData = try Data.init(contentsOf: webURL)
            if debug {
                Aurora.shared.log("Saving <\(T.self)> to \(cache.path)")
            }
            try? jsonData.write(to: cache)
            return parse(json: jsonData)
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
            Aurora.shared.log("Error: \(error)")
            Aurora.shared.log("Failed to decode <\(T.self)>")
            return nil
        }
    }
}
