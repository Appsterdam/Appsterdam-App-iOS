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

struct PersonModel: Codable {
    var team: String
    var members: [Person]
}

// Make it work in SwiftUI Views
extension PersonModel: Identifiable {
    var id: UUID {
        return UUID()
    }
}
