//
//  AppsterdamApp.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 23/01/2022.
//

import SwiftUI
import BackgroundTasks
import Aurora

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
        WindowGroup {
            MainView()
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        Aurora.shared.log("Active")
                    } else if newPhase == .inactive {
                        Aurora.shared.log("Inactive")
                    } else if newPhase == .background {
                        if Settings.shared.disableCache {
                            Aurora.shared.log("Enabling cache")
                            Settings.shared.disableCache = false
                        }

                        Aurora.shared.log("Background")
                    }
                }
        }
    }
}
