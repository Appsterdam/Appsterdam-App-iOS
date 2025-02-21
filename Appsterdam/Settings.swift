//
//  Settings.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 21/01/2022.
//

import SwiftUI
import SwiftExtras

class Settings {
    /// Static variable settings
    public static let shared = Settings()

    // MARK: APP Stats/settings
    /// how many times the app is openend?
    @AppStorage("app.appruns")
    var appRuns: Int = 0

    @AppStorage("app.eventsCount")
    /// how much events do we have?
    var appEventsCount: String = "0"

    /// how many times the app is openend (TXT)?
    @AppStorage("app.apprunsTXT")
    var appRunsTXT: String = "0"

    /// When did the last background update happen
    @AppStorage("app.lastUpdate")
    var lastUpdate: String = "Never"

    /// Reset cache
    @AppStorage("app.disableCache")
    var disableCache: Bool = false

    // MARK: About settings
    /// Open about links in app (safari)?
    @AppStorage("about.openInApp")
    var aboutOpenInApp: Bool = true

    // MARK: Events
    /// Open events in app (safari)
    @AppStorage("events.openInApp")
    var eventsOpenInApp: Bool = true

    /// Enable search in events
    @AppStorage("events.enableSearch")
    var eventsEnableSearch: Bool = true

    /// Show event description?
    @AppStorage("events.description")
    var eventsDescription: Bool = false

    /// Show icon in event list
    @AppStorage("events.showIcon")
    var eventsShowIcon: Bool = true

    /// Notify on new events
    @AppStorage("events.notify")
    var eventsNotify: Bool = true

    /// Enable job search
    @AppStorage("jobs.enable")
    var jobsEnable: Bool = true

    /// Jobs counter
    @AppStorage("jobs.count")
    var jobsCount: String = "None"

    /// Notify on new jobs
    @AppStorage("jobs.notify")
    var jobsNotify: Bool = false

    init() {
        appRuns += 1
        appRunsTXT = "\(appRuns)"

        // Log app runs, will not display on non-debug builds
        print("App runs: \(appRuns)")
    }

    deinit {

    }
}
