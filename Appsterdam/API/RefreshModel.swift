//
//  Background Fetch.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 12/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import Foundation
import BackgroundTasks
import OSLog

/// Refresh model:
///
/// To debug:
/// minimize app, press pause and enter this code in the debugger:
///
/// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"rs.appsterdam.refresh"]
public class RefreshModel {
    let taskIdentifier = "rs.appsterdam.refresh"
    let runAfter: Double = 3600 * 24 // Once a day.
    let logger = Logger(subsystem: "rs.appsterdam", category: "refresh model")

    /// Static variable settings
    public static let shared = RefreshModel()

    /// Initialize class.
    init () {
        logger.debug("Refresh Model (last refresh: \(Settings.shared.lastUpdate))")
    }

    /// Register the task
    public func register() {
        logger.debug("Registered task: \(self.taskIdentifier).")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
            // swiftlint:disable:previous force_cast
        }
    }

    /// Schedule a new refresh
    public func scheduleAppRefresh() {
        logger.debug("Registered \(self.taskIdentifier), earliest time: \(self.runAfter)")
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: runAfter)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            logger.debug("Could not schedule app refresh: \(error)")
        }
    }

    /// Log all pending requests
    public func logAllRequests() {
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            print(requests)
        }
    }

    /// Handle the refresh request
    /// - Parameter task: iOS task
    public func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()

        task.expirationHandler = {
            self.logger.debug("Refresh expired")
            Settings.shared.lastUpdate = "Failed"
            task.setTaskCompleted(success: false)
        }

        // Load App
        Model<AppModel>.init(
            url: "https://appsterdam.rs/api/app.json"
        ).update()

        // Load Events
        Model<EventModel>.init(
            url: "https://appsterdam.rs/api/events.json"
        ).update()

        // Load Jobs
        Model<JobsModel>.init(
            url: "https://appsterdam.rs/api/jobs.json"
        ).update()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        Settings.shared.lastUpdate = formatter.string(from: Date())

        task.setTaskCompleted(success: true)
    }
}
