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
