//
//  AppDelegate.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 12/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import Foundation
import SwiftUI
import BackgroundTasks
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate {
    let refresh = "rs.appsterdam.refresh"
    let process = "rs.appsterdam.process"

    let fetchTime: Double = 3600 * (24 * 3) // 3 days.

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
print("AAA")
        
        // ASKING PERMISSION FOR NOTIFICATIONS
        // WORST WAY POSSIBLE, should be asked somewhere else.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        // END OF ASKING PERMISSION FOR NOTIFICATIONS

        sheduleFetch()

        // Use the identifier which represents your needs
        BGTaskScheduler.shared.register(forTaskWithIdentifier: process, using: nil) { (task) in
            print("BackgroundAppRefreshTaskScheduler is executed NOW!")
            print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }

            // Do some data fetching and call setTaskCompleted(success:) asap!
            let isFetchingSuccess = true
            task.setTaskCompleted(success: isFetchingSuccess)
        }

        return true
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        sheduleFetch()
    }

    func sheduleFetch() {
            let refreshDataTask = BGAppRefreshTaskRequest(identifier: refresh)
            refreshDataTask.earliestBeginDate = Date(timeIntervalSinceNow: fetchTime)
            do {
                try BGTaskScheduler.shared.submit(refreshDataTask)
            } catch {
                print("Unable to submit task: \(error.localizedDescription)")
            }
    }

    func notify(message: String, subtitle: String?) {
        let content = UNMutableNotificationContent()
        content.title = message
        content.subtitle = subtitle ?? ""

//        content.sound = UNNotificationSound.default
        content.sound = nil

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
