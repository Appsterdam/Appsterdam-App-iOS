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

    // MARK: About settings
    @UserDefault("about.openInApp", default: true)
    /// Open about links in app (safari)?
    var aboutOpenInApp: Bool

    // MARK: Events
    @UserDefault("events.openInApp", default: true)
    /// Open events in app (safari)
    var eventsOpenInApp: Bool

    @UserDefault("events.hideSearch", default: true)
    /// Hide search in events
    var eventsHideSearch: Bool

    @UserDefault("events.description", default: true)
    /// Show event description?
    var eventsDescription: Bool

    // MARK: Appsterdam User Account
    @Keychain(item: "appsterdam.username")
    var appsterdam_username: String?

    @Keychain(item: "appsterdam.password")
    var appsterdam_password: String?

    init() {
        appRuns += 1

        // Log app runs, will not display on non-debug builds
        Aurora.shared.log("App runs: \(appRuns)")
    }

    deinit {

    }
}
