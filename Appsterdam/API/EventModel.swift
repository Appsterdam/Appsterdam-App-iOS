//
//  EventData.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 23/01/2022.
//  Copyright © 2022 Appsterdam. All rights reserved.
//

import Foundation

struct event: Codable, Identifiable {
    var id = UUID() // String // meetup id.
    var name: String
    var description: String
    var date: Date
    var attendees: Int
    var image: String
}
