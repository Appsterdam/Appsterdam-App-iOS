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

    @Model("https://appsterdam.rs/api/events.json")
    private var events: [EventModel]

    var body: some View {
        let navigation = NavigationView {
            List {
                if searchResults.isEmpty, !searchText.isEmpty {
                    EmptySearchResultsView(searchText: searchText)
                        .listRowBackground(Color.clear)
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
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .appGroupedBackground()
            .navigationTitle("Events")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await $events.update()
            }
            .onChange(of: events.count) { _ in
                updateEventCount()
            }
            .onAppear {
                updateEventCount()
                enableSearch = Settings.shared.eventsEnableSearch
            }
            .sheet(item: $selectedEvent, content: EventView.init)
        }

        if enableSearch {
            navigation
                .navigationViewStyle(.stack)
                .searchable(text: $searchText, prompt: "Search events")
        } else {
            navigation
                .navigationViewStyle(.stack)
        }
    }

    private var searchResults: [EventModel] {
        guard !searchText.isEmpty else {
            return events
        }

        return events.compactMap { section in
            let matchingEvents = section.events.filter { event in
                event.name.localizedStandardContains(searchText)
                    || event.description.localizedStandardContains(searchText)
                    || event.date.localizedStandardContains(searchText)
            }
            return matchingEvents.isEmpty ? nil : EventModel(name: section.name, events: matchingEvents)
        }
    }

    private func updateEventCount() {
        let eventCount = events.map(\.events.count).reduce(0, +)
        Settings.shared.appEventsCount = "\(eventCount)"

        let eventIDs = EventUpdateDetector.eventIDs(in: events)
        Settings.shared.eventsKnownIDs = EventUpdateDetector.storageString(from: eventIDs)
    }
}

private struct EmptySearchResultsView: View {
    let searchText: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("No results found")
                .font(.headline)

            Text("No events match \"\(searchText)\".")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    EventListView()
}
