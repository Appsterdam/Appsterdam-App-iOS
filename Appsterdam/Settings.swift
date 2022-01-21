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

    @UserDefault("showSectionIndexTitles", default: false)
    /// Show section index titles
    var showSectionIndexTitles: Bool

    @UserDefault("Appruns", default: 0)
    /// how many times the app is openend?
    var appRuns: Int

    @Keychain(item: "appsterdam.username")
    var appsterdam_username: String?

    @Keychain(item: "appsterdam.password")
    var appsterdam_password: String?

    init() {
        appRuns += 1
    }

    deinit {

    }
}
