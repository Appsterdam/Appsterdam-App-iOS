//
//  Settings.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 21/01/2022.
//

import Foundation
import Aurora

class Settings {
    /// Static variable settings
    public static let shared = Settings()

    // MARK: APP Stats/settings
    @UserDefault("app.appruns", default: 0)
    /// how many times the app is openend?
    var appRuns: Int

    @UserDefault("app.eventsCount", default: "0")
    /// how much events do we have?
    var appEventsCount: String

    @UserDefault("app.apprunsTXT", default: "0")
    /// how many times the app is openend (TXT)?
    var appRunsTXT: String

    // MARK: About settings
    @UserDefault("about.openInApp", default: true)
    /// Open about links in app (safari)?
    var aboutOpenInApp: Bool

    // MARK: Events
    @UserDefault("events.openInApp", default: true)
    /// Open events in app (safari)
    var eventsOpenInApp: Bool

    @UserDefault("events.enableSearch", default: true)
    /// Enable search in events
    var eventsEnableSearch: Bool

    @UserDefault("events.description", default: false)
    /// Show event description?
    var eventsDescription: Bool

    @UserDefault("events.showIcon", default: true)
    /// Show icon in event list
    var eventsShowIcon: Bool

    // MARK: Appsterdam User Account
    @Keychain(item: "appsterdam.username")
    var appsterdam_username: String?

    @Keychain(item: "appsterdam.password")
    var appsterdam_password: String?

    init() {
        appRuns += 1
        appRunsTXT = "\(appRuns)"

        // Log app runs, will not display on non-debug builds
        Aurora.shared.log("App runs: \(appRuns)")
    }

    deinit {

    }
}
