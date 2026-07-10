//
//  EventView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI

struct EventListView: View {
    @State private var searchText = ""
    @State private var enableSearch = Settings.shared.eventsEnableSearch
    @State private var selectedEvent: Event?

    @StateObject private var events = Model<[EventModel]>.init(
        url: "https://appsterdam.rs/api/events.json"
    )

    var body: some View {
        let navigation = NavigationStack {
            List {
                if searchResults.isEmpty, !searchText.isEmpty {
                    Text("No results found")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(searchResults) { section in
                        Section(section.name) {
                            ForEach(section.events) { event in
                                Button {
                                    selectedEvent = event
                                } label: {
                                    EventCell(event: event)
                                }
                                .buttonStyle(CellButtonStyle())
                            }
                        }
                    }
                }
            }
            .navigationTitle("Events")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await events.update()
            }
            .onChange(of: events.model?.count) { _ in
                updateEventCount()
            }
            .onAppear {
                updateEventCount()
                enableSearch = Settings.shared.eventsEnableSearch
            }
            .sheet(item: $selectedEvent, content: EventView.init)
        }

        if enableSearch {
            navigation.searchable(text: $searchText)
        } else {
            navigation
        }
    }

    private var searchResults: [EventModel] {
        guard !searchText.isEmpty else {
            return events.model ?? []
        }

        return events.model?.compactMap { section in
            let matchingEvents = section.events.filter { event in
                event.name.localizedStandardContains(searchText)
                    || event.description.localizedStandardContains(searchText)
                    || event.date.localizedStandardContains(searchText)
            }
            return matchingEvents.isEmpty ? nil : EventModel(name: section.name, events: matchingEvents)
        } ?? []
    }

    private func updateEventCount() {
        let eventCount = events.model?.map(\.events.count).reduce(0, +) ?? 0
        Settings.shared.appEventsCount = "\(eventCount)"
    }
}

#Preview {
    EventListView()
}
