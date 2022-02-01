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

@available(swift, deprecated: 0.1, message: "Please use Model<T>")
class PersonModel {
    let url = URL(string: "https://appsterdam.rs/api/people.json")!
    let cache = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("people")
    let maxAge: Double = 3600 * 24 * 7 // Keep one week.

    init() {
        // Reload (in background)
        DispatchQueue.global(qos: .background).async {
            self.reloadFromWebsite()
        }
    }

    func load(_ testData: Bool = false) -> [PersonArray] {
        if testData {
            guard let testPeople = loadFromTest() else {
                Aurora.shared.log("This should never happen, something is corrupt (people).\ncrashing")
                fatalError("This should never fail")
            }

            return testPeople
        }

        // Check, if we have at least 1 person
        guard let persons = loadFromCache() else {
            guard let fetchedPersons = self.reloadFromWebsite() else {
                return [
                    .init(
                        team: "Failed to load",
                        members: [
                            .init(name: "Please restart", picture: "", function: "")
                        ]
                    )
                ]
            }

            // Return team list (from internet)
            return fetchedPersons
        }

        // Return team list (from cache).
        return persons
    }

    private func loadFromTest() -> [PersonArray]? {
        // Load from cache, and refresh in background.
        guard let url = Bundle.main.url(forResource: "people", withExtension: "json") else {
            Aurora.shared.log("Could't find people.json")
            return nil
        }

        do {
            let jsonData = try Data.init(contentsOf: url)
            Aurora.shared.log("Loaded people.json from test")
            return parse(json: jsonData)
        } catch {
            Aurora.shared.log("Error: \(error)")
        }

        return nil
    }

    private func loadFromCache() -> [PersonArray]? {
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
    private func reloadFromWebsite() -> [PersonArray]? {
        do {
            let jsonData = try Data.init(contentsOf: url)
            try? jsonData.write(to: cache)
            return parse(json: jsonData)
        } catch {
            Aurora.shared.log("Error: \(error.localizedDescription)")
        }

        return nil
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
