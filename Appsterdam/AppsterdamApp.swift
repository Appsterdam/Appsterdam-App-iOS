//
//  AppsterdamApp.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 23/01/2022.
//

import SwiftUI

@main
struct AppsterdamApp: App {
    var settings = Settings.shared

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
