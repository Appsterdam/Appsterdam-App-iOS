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
    private var refreshTask: Task<Void, Never>?

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
            guard let task = task as? BGAppRefreshTask else {
                task.setTaskCompleted(success: false)
                return
            }
            self.handleAppRefresh(task: task)
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

        task.expirationHandler = { [weak self] in
            self?.refreshTask?.cancel()
            self?.logger.debug("Refresh expired")
            Settings.shared.lastUpdate = "Failed"
        }

        refreshTask = Task { @MainActor in
            // Load App
            async let app = Model<AppModel>.init(
                url: "https://appsterdam.rs/api/app.json",
                automaticallyLoads: false
            ).update()

            // Load Events
            async let events = Model<[EventModel]>.init(
                url: "https://appsterdam.rs/api/events.json",
                automaticallyLoads: false
            ).update()

            // Load Jobs
            async let jobs = Model<[JobsModel]>.init(
                url: "https://appsterdam.rs/api/jobs.json",
                automaticallyLoads: false
            ).update()

            guard !Task.isCancelled else {
                task.setTaskCompleted(success: false)
                return
            }

            let results = await (app, events, jobs)
            let succeeded = results.0 != nil && results.1 != nil && results.2 != nil
            Settings.shared.lastUpdate = succeeded ? Date.now.formatted() : "Failed"
            task.setTaskCompleted(success: succeeded)
        }
    }
}
