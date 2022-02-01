//
//  Model.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 01/02/2022.
//

import Foundation
import Aurora

class Model<T: Codable> {
    let webURL: URL
    let cache: URL
    let maxAge: Double = 3600 * 24 * 7 // Keep one week.
    let debug: Bool = true

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

    func load(_ testData: Bool = false) -> [T] {
        // Reload (in background) after 10 seconds.
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 10) {
            self.loadFromWebsite()
        }

        // Check, if we have at least 1 person
        guard let events = loadFromCache() else {
            guard let fetchedEvents = loadFromWebsite() else {
                Aurora.shared.log("This should never happen, something is corrupt.\nCannot create: \(T.self)")
                fatalError()
            }

            // Return list from web
            return fetchedEvents
        }

        // Return team list.
        return events
    }

    private func isCacheValid(_ refresh: Double = 0) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: cache.path) {
                let attributes = try FileManager.default.attributesOfItem(atPath: cache.path)

                if let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date,
                   Date().unixTime < modificationDate.unixTime + maxAge - refresh {
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

    @discardableResult
    private func loadFromWebsite() -> [T]? {
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


    private func parse(json: Data) -> [T]? {
        let decoder = JSONDecoder()

        do {
            return try decoder.decode([T].self, from: json)
        } catch {
            Aurora.shared.log("Error: \(error)")
            Aurora.shared.log("Failed to decode <\(T.self)>")
            return nil
        }
    }
}
