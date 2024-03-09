//
//  EventData.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 23/01/2022.
//  Copyright © 2022 Appsterdam. All rights reserved.
//

import Foundation

struct Event: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var price: String
    var organizer: String
    var location_name: String
    var location_address: String
    var date: String
    var attendees: String
    var icon: String
    var latitude: String
    var longitude: String
}

struct EventModel: Codable {
    var name: String
    var events: [Event]
}

// Make it work in SwiftUI Views
extension EventModel: Identifiable {
    var id: UUID {
        return UUID()
    }
}
