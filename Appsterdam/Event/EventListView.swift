//
//  EventView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI
import Aurora
import UIKit

struct EventListView: View {
    @State var showsEvent: Bool = false
    @State var showEvent: Event = .init(
        id: "0",
        name: "",
        description: "",
        price: 0,
        organizer: "Appsterdam",
        location: "",
        address: "",
        latitude: 52.3655891418457,
        longitude: 4.867978096008301,
        date: "",
        attendees: 0,
        icon: ""
    )

    let events = EventModel().load()

    var body: some View {
        List() {
            ForEach(events) { section in
                Section(header: Text(section.name)) {
                    ForEach(section.events) { event in
                        EventCell(event: event)
                            .onTapGesture {
                                self.showEvent = event
                                self.showsEvent.toggle()
                            }
                    }
                }
                .headerProminence(.increased)
            }
        }
        .sheet(isPresented: $showsEvent, content: {
            EventView(displayEvent: $showEvent)
        })
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}
