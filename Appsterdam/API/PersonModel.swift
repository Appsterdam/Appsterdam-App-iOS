//
//  PersonModel.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 24/01/2022.
//

import Foundation
import Aurora

struct Person: Codable  {
    var name: String
    var picture: String?
    var function: String
}

// Make it work in SwiftUI Views
extension Person: Identifiable {
    var id: UUID {
        return UUID()
    }
}

struct PersonArray: Codable {
    var team: String
    var members: [Person]
}

// Make it work in SwiftUI Views
extension PersonArray: Identifiable {
    var id: UUID {
        return UUID()
    }
}

class PersonModel {
    init() {

    }

    func load() -> [PersonArray] {
        // Reload (in background)
        DispatchQueue.global(qos: .background).async {
            self.reloadFromWebsite()
        }

        // Check, if we have at least 1 person
        guard let persons = loadFromCache() else {
            Aurora.shared.log("This should never happen, something is corrupt.\ndelivering a empty person")

            return [
                .init(team: "_", members: [
                    .init(
                        name: "Error",
                        picture: nil,
                        function: "Failed to load"
                    )
                ])
            ]
        }

        // Return team list.
        return persons
    }

    private func loadFromCache() -> [PersonArray]? {
        // Load from cache, and refresh in background.
        guard let url = Bundle.main.url(forResource: "people", withExtension: "json") else {
            Aurora.shared.log("Could't find people.json")
            return nil
        }

        do {
            let jsonData = try Data.init(contentsOf: url)
            return parse(json: jsonData)
        } catch {
            Aurora.shared.log("Error: \(error.localizedDescription)")
        }

        return nil
    }

    private func reloadFromWebsite() {
        // TODO: Fetch real data.
    }

    private func parse(json: Data) -> [PersonArray]? {
        let decoder = JSONDecoder()

        do {
            return try decoder.decode([PersonArray].self, from: json)
        } catch {
            Aurora.shared.log("Error: \(error)")
            Aurora.shared.log("Failed to decode persons")
            return nil
        }
    }
}
