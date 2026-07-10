//
//  PersonModel.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 24/01/2022.
//

import Foundation

struct Person: Codable, Equatable, Identifiable {
    var name: String
    var picture: String?
    var function: String
    var twitter: String?
    var linkedin: String?
    var website: String?
    var bio: String

    var id: String { name }
}

struct PersonModel: Codable, Equatable, Identifiable {
    var team: String
    var members: [Person]

    var id: String { team }
}
