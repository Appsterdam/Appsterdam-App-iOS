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
import UserNotifications

public class RefreshModel {
    let taskIdentifier = "rs.appsterdam.refresh"
    let runAfter: Double = 30 // 10 * 60

    /// Static variable settings
    public static let shared = RefreshModel()

    init () {
        Aurora.shared.log("Refresh Model")

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    public func register() {
        Aurora.shared.log("Registered task: \(taskIdentifier).")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    public func scheduleAppRefresh() {
        Aurora.shared.log("Registered \(taskIdentifier), earliest time: \(runAfter)")
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: runAfter)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            Aurora.shared.log("Could not schedule app refresh: \(error)")
        }

        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            Aurora.shared.log(requests)
        }
    }

    public func handleAppRefresh(task: BGAppRefreshTask) {
        print("Start refeshing...")
        scheduleAppRefresh()

        task.expirationHandler = {
            print("expired")
            task.setTaskCompleted(success: false)
        }

        // Load About
        let persons = Model<PersonModel>.init(
            url: "https://appsterdam.rs/api/people.json"
        ).update()

        // Load Events
        let events = Model<EventModel>.init(
            url: "https://appsterdam.rs/api/events.json"
        ).update()

        print("Updated: \(persons?.count) PPL Cat, \(events?.count) Event years.")
        sendNotification(title: "Updated", message: "\(events?.count) Event years.")

        task.setTaskCompleted(success: true)
    }

    public func sendNotification(title: String, message: String?) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = message ?? ""
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
