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


class EventModel {
    init() {

    }

    func load() -> [EventArray] {
        // Reload (in background)
        DispatchQueue.global(qos: .background).async {
            self.reloadFromWebsite()
        }

        // Check, if we have at least 1 person
        guard let events = loadFromCache() else {
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

        // Return team list.
        return events
    }

    private func loadFromCache() -> [EventArray]? {
        // Load from cache, and refresh in background.
        guard let url = Bundle.main.url(forResource: "test-events", withExtension: "json") else {
            Aurora.shared.log("Could't find test-events.json")
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

    private func reloadFromWebsite() {
        // TODO: Fetch real data.
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
