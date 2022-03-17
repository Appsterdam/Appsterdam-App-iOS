//
//  AppModel.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 17/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import Foundation

struct AppModel: Codable {
    var home: String
    var people: [PersonModel]?
}

// Make it work in SwiftUI Views
extension AppModel: Identifiable {
    var id: UUID {
        return UUID()
    }
}
