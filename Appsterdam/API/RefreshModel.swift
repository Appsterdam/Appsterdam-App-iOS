//
//  Background Fetch.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 12/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import Foundation
import BackgroundTasks
import Aurora

/// Refresh model:
///
/// To debug:
/// minimize app, press pause and enter this code in the debugger:
///
///     e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"rs.appsterdam.refresh"]
public class RefreshModel {
    let taskIdentifier = "rs.appsterdam.refresh"
    let runAfter: Double = 3600 * 24 // Once a day.

    /// Static variable settings
    public static let shared = RefreshModel()

    /// Initialize class.
    init () {
        Aurora.shared.log("Refresh Model (last refresh: \(Settings.shared.lastUpdate))")
    }

    /// Register the task
    public func register() {
        Aurora.shared.log("Registered task: \(taskIdentifier).")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    /// Schedule a new refresh
    public func scheduleAppRefresh() {
        Aurora.shared.log("Registered \(taskIdentifier), earliest time: \(runAfter)")
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: runAfter)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            Aurora.shared.log("Could not schedule app refresh: \(error)")
        }
    }

    /// Log all pending requests
    public func logAllRequests() {
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            Aurora.shared.log(requests)
        }
    }

    /// Handle the refresh request
    /// - Parameter task: iOS task
    public func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()

        task.expirationHandler = {
            Aurora.shared.log("Refresh expired")
            task.setTaskCompleted(success: false)
        }

        // Load About
        Model<PersonModel>.init(
            url: "https://appsterdam.rs/api/people.json"
        ).update()

        // Load Events
        Model<EventModel>.init(
            url: "https://appsterdam.rs/api/events.json"
        ).update()

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"

        Settings.shared.lastUpdate = df.string(from: Date())

        task.setTaskCompleted(success: true)
    }
}
