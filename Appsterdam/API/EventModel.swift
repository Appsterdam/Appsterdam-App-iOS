//
//  EventData.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 23/01/2022.
//  Copyright © 2022 Appsterdam. All rights reserved.
//

import Foundation

struct Event: Codable, Equatable, Identifiable {
    var id: String
    var name: String
    var description: String
    var price: String
    var organizer: String
    var locationName: String
    var locationAddress: String
    var date: String
    var attendees: String
    var icon: String
    var latitude: String
    var longitude: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, price, organizer, date, attendees, icon, latitude, longitude
        case locationName = "location_name"
        case locationAddress = "location_address"
    }
}

struct EventModel: Codable, Equatable, Identifiable {
    var name: String
    var events: [Event]

    var id: String { name }
}
