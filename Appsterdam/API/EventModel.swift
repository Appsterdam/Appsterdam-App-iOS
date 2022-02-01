//
//  EventData.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 23/01/2022.
//  Copyright © 2022 Appsterdam. All rights reserved.
//

import Foundation
import Aurora

struct Event: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var price: Int
    var organizer: String
    var location: String
    var address: String
    var date: String
    var attendees: Int
    var icon: String
}

struct EventArray: Codable {
    var name: String
    var events: [Event]
}

// Make it work in SwiftUI Views
extension EventArray: Identifiable {
    var id: UUID {
        return UUID()
    }
}

@available(swift, deprecated: 0.1, message: "Please use Model<T>")
class EventModel {
    let url = URL(string: "https://appsterdam.rs/api/events.json")!
    let cache = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("event")
    let maxAge: Double = 3600 * 24 * 7 // Keep one week.

    init() {

    }

    func load(_ testData: Bool = false) -> [EventArray] {
        if testData {
            guard let testEvents = loadFromTest() else {
                Aurora.shared.log("This should never happen, something is corrupt (events).\ncrashing")
                fatalError("This should never fail")
            }

            return testEvents
        }

        // Reload (in background)
        DispatchQueue.global(qos: .background).async {
            self.reloadFromWebsite()
        }

        // Check, if we have at least 1 person
        guard let events = loadFromCache() else {
            guard let fetchedEvents = self.reloadFromWebsite() else {
                Aurora.shared.log("This should never happen, something is corrupt.\ndelivering a empty person")

                return [
                    .init(
                        name: "Failed to load",
                        events: [
                            .init(
                                id: "0",
                                name: "Failed",
                                description: "Failed to load",
                                price: 0,
                                organizer: "Appsterdam",
                                location: "",
                                address: "",
                                date: "",
                                attendees: 0,
                                icon: "exclamationmark.arrow.triangle.2.circlepath"
                            )
                        ]
                    )
                ]
            }
            // Return list from web
            return fetchedEvents
        }

        // Return team list.
        return events
    }


    private func loadFromTest() -> [EventArray]? {
        // Load from cache, and refresh in background.
        guard let url = Bundle.main.url(forResource: "events", withExtension: "json") else {
            Aurora.shared.log("Could't find events.json")
            return nil
        }

        do {
            let jsonData = try Data.init(contentsOf: url)
            return parse(json: jsonData)
        } catch {
            Aurora.shared.log("Error: \(error)")
        }

        return nil
    }

    private func loadFromCache() -> [EventArray]? {
        do {
            if FileManager.default.fileExists(atPath: cache.path) {
                let attributes = try FileManager.default.attributesOfItem(atPath: cache.path)

                if let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date,
                   Date().unixTime < modificationDate.unixTime + maxAge {
                    let jsonData = try Data.init(contentsOf: cache)
                    return parse(json: jsonData)
                }
            }
        } catch {
            Aurora.shared.log("Error: \(error.localizedDescription)")
        }

        return nil
    }

    @discardableResult
    private func reloadFromWebsite() -> [EventArray]? {
        do {
            let jsonData = try Data.init(contentsOf: url)
            try? jsonData.write(to: cache)
            return parse(json: jsonData)
        } catch {
            Aurora.shared.log("Error: \(error.localizedDescription)")
        }

        return nil
    }


    private func parse(json: Data) -> [EventArray]? {
        let decoder = JSONDecoder()

        do {
            return try decoder.decode([EventArray].self, from: json)
        } catch {
            Aurora.shared.log("Error: \(error)")
            Aurora.shared.log("Failed to decode events")
            return nil
        }
    }
}
