//
//  AppsterdamApp.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 23/01/2022.
//

import SwiftUI
import BackgroundTasks

@main
struct AppsterdamApp: App {
    @Environment(\.scenePhase) var scenePhase

    var settings = Settings.shared
    var data = RefreshModel.shared

    init() {
        data.register()
        data.scheduleAppRefresh()
    }

    var body: some Scene {
        WindowGroup("Appsterdam App") {
            MainView()
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .background {
                        if Settings.shared.disableCache {
                            Settings.shared.disableCache = false
                        }
                    }
                }
        }
    }
}
