//
//  EventView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI
import Aurora
import UIKit

class alertView {
    @discardableResult
    init(title: String, message: String) {
        let alert = UIAlertController.init(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            .init(title: "Ok",
                  style: .default,
                  handler: nil)
        )

//         UIApplication.shared.windows.first { $0.isKeyWindow }
        // to
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController?
            .present(alert, animated: true, completion: nil)
    }
}

struct EventView: View {
    var events: [event] = [
        event.init(name: "Weekly meeten & drinken", description: "Hap", date: .init(), attendees: 1, image: "🍺"),
        event.init(name: "Coffee coding", description: ".", date: .init(), attendees: 1, image: "laptopcomputer.and.iphone"),
        event.init(name: "Weekend fun", description: ".", date: .init(), attendees: 1, image: "star"),

        event.init(name: "Weekly meeten & drinken", description: "Hap", date: .init(), attendees: 1, image: "🍺"),
        event.init(name: "Coffee coding", description: ".", date: .init(), attendees: 1, image: "laptopcomputer.and.iphone"),
        event.init(name: "Weekend fun", description: ".", date: .init(), attendees: 1, image: "star"),

        event.init(name: "Weekly meeten & drinken", description: "Hap", date: .init(), attendees: 1, image: "🍺"),
        event.init(name: "Coffee coding", description: ".", date: .init(), attendees: 1, image: "laptopcomputer.and.iphone"),
        event.init(name: "Weekend fun", description: ".", date: .init(), attendees: 1, image: "star"),

        event.init(name: "ZOO", description: ".", date: .init(), attendees: 1, image: "🐘")
    ]

    var body: some View {
        List() {
        Section(header: Text("Upcoming")) {
            ForEach(events) { event in
                EventCell(event: event)
                    .onTapGesture {
                        let _ = print(
                            "Tapped event \(event)"
                        )

                        alertView(
                            title: "Tapped event",
                            message: """
id: \(event.id)
name: \(event.name)
description: \(event.description)
""")
                    }
            }
        }
        .headerProminence(.increased)

        Section(header: Text("Past")) {
            ForEach(events) {
                EventCell(event: $0)
            }
        }
        .headerProminence(.increased)

        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}
