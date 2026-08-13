//
//  EventCell.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 23/01/2022.
//  Copyright © 2022 Appsterdam. All rights reserved.
//

import SwiftUI

struct EventCell: View {
    var event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                EventDatePill(month: monthText, day: dayText)

                VStack {
                    Text(.init(event.name))
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if Settings.shared.eventsDescription, !event.description.isEmpty {
                        Text(.init(event.description))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
            }

            VStack(alignment: .trailing, spacing: 8) {
                HStack(spacing: 8) {
                    Spacer()

                    MetadataChip(
                        title: event.organizer,
                        systemImage: "person"
                    )

                    MetadataChip(
                        title: event.locationName,
                        systemImage: "mappin.and.ellipse"
                    )

                    MetadataChip(
                        title: event.attendees,
                        systemImage: "person.2"
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(14)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }

    private var eventDate: Date? {
        EventDateFormatter.date(from: event.date)
    }

    private var monthText: String {
        guard let eventDate else {
            return "--"
        }

        return eventDate.formatted(.dateTime.month(.abbreviated))
    }

    private var dayText: String {
        guard let eventDate else {
            return "--"
        }

        return eventDate.formatted(.dateTime.day())
    }

    private var accessibilityText: String {
        [
            event.name,
            EventDateFormatter.string(from: event.date),
            "\(event.attendees) attendees"
        ].joined(separator: ", ")
    }
}

private struct EventDatePill: View {
    let month: String
    let day: String

    var body: some View {
        VStack(spacing: 2) {
            Text(month.uppercased())
                .font(.caption2.weight(.bold))

            Text(day)
                .font(.title3.weight(.semibold))
        }
        .foregroundStyle(AppTheme.accent)
        .frame(width: 52, height: 52)
        .background(Color(uiColor: .tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
        .accessibilityHidden(true)
    }
}

private struct MetadataChip: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption)
            .lineLimit(1)
            .foregroundStyle(.secondary)

    }
}

#Preview {
    EventCell(event: Mock.event)
}
