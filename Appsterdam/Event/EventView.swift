//
//  EventView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 25/01/2022.
//

import SwiftUI
import SwiftExtras

struct EventView: View {
    let displayEvent: Event

    var body: some View {
        CardView(
            title: displayEvent.name,
            subtitle: displayEvent.locationName
        ) {
            VStack(spacing: 16) {
                EventHeroImage(imageURL: imageURL)
                    .frame(height: 270)

                EventInfoCard(
                    event: displayEvent,
                    isOnlineEvent: isOnlineEvent,
                    mapsURL: mapsURL
                )

                EventDescriptionCard(
                    description: displayEvent.description
                )
            }
            .padding(.bottom, 40)
        }
        .overlay(alignment: .bottom) {
            Group {
                if #available(iOS 26.0, *) {
                    meetupButton
                        .buttonStyle(.glass)
                } else {
                    meetupButton
                        .buttonStyle(.borderedProminent)
                }
            }
            .controlSize(.large)
            .accessibilityLabel("\(attendanceAction) \(displayEvent.name) on Meetup")
            .accessibilityHint("Opens this event on Meetup")
            .padding(.bottom)
        }
    }

    private var meetupButton: some View {
        Button {
            openMeetupEvent()
        } label: {
            Label("\(attendanceAction) on Meetup", systemImage: "arrow.up.forward.app")
                .font(.headline)
        }
    }

    private var attendanceAction: String {
        guard let eventDate = EventDateFormatter.date(from: displayEvent.date) else {
            return "Attend"
        }

        return Date.now > eventDate ? "View" : "Attend"
    }

    private var isOnlineEvent: Bool {
        displayEvent.locationName.localizedCaseInsensitiveContains("http")
        || displayEvent.locationName.localizedCaseInsensitiveContains("online")
    }

    private var imageURL: URL? {
        var components = URLComponents(string: "https://appsterdam.rs/api/getImage.php")
        components?.queryItems = [
            URLQueryItem(name: "eid", value: displayEvent.id),
            URLQueryItem(name: "for", value: displayEvent.name)
        ]

        if displayEvent.icon.contains("http", caseSensitive: false) {
            return URL(string: displayEvent.icon)
        }

        return components?.url
    }

    private var mapsURL: URL? {
        var components = URLComponents(string: "https://maps.apple.com/")
        components?.queryItems = [
            URLQueryItem(name: "daddr", value: "\(displayEvent.locationAddress),Netherlands")
        ]
        return components?.url
    }

    private func openMeetupEvent() {
        let eventURL = "Appsterdam/events/\(displayEvent.id)/"
        guard
            let meetupURL = URL(string: "https://www.meetup.com/\(eventURL)"),
            let deeplinkURL = URL(string: "meetup://\(eventURL)") else {
            return
        }

        Task {
            let didOpenURL = await UIApplication.shared.open(deeplinkURL)
            if !didOpenURL {
                await UIApplication.shared.open(meetupURL)
            }
        }
    }
}

private struct EventHeroImage: View {
    let imageURL: URL?

    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
            case .failure:
                EventFallbackHero()
            case .empty:
                EventFallbackHero(showProgress: true)
            @unknown default:
                EventFallbackHero()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

private struct EventFallbackHero: View {
    var showProgress = false

    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemGroupedBackground)

            if showProgress {
                ProgressView()
                    .controlSize(.large)
            } else {
                Image("Appsterdam_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .opacity(0.7)
            }
        }
    }
}

private struct EventDateBadge: View {
    let date: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar.badge.clock")

            Text(EventDateFormatter.string(from: date))
                .lineLimit(1)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(.black.opacity(0.42), in: Capsule())
    }
}

private struct EventInfoCard: View {
    let event: Event
    let isOnlineEvent: Bool
    let mapsURL: URL?

    var body: some View {
        VStack(spacing: 14) {
            EventDetailRow(
                systemImage: "calendar.badge.clock",
                title: "Date",
                value: EventDateFormatter.string(from: event.date)
            )

            if isOnlineEvent {
                EventDetailRow(
                    systemImage: "video",
                    title: "Location",
                    value: "Online event"
                )
            } else if let mapsURL {
                Button {
                    UIApplication.shared.open(mapsURL)
                } label: {
                    EventDetailRow(
                        systemImage: "mappin.and.ellipse",
                        title: "Location",
                        value: event.locationName,
                        accessorySystemImage: "arrow.up.right"
                    )
                }
                .buttonStyle(.plain)
                .accessibilityHint("Opens directions in Maps")
            }

            EventDetailRow(
                systemImage: "person",
                title: "Organised by",
                value: event.organizer
            )
            EventDetailRow(
                systemImage: "person.2",
                title: "Attendees",
                value: event.attendees
            )
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(
            AppTheme.cardBackground,
            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
        )
    }
}

private struct EventDescriptionCard: View {
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("About this event", systemImage: "text.alignleft")
                .font(.headline)

            ForEach(Array(EventDescriptionParser.blocks(from: description).enumerated()), id: \.offset) { _, block in
                switch block {
                case .text(let text):
                    Text(.init(text))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineSpacing(3)

                case .image(let image):
                    EventDescriptionImage(image: image)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

private struct EventDescriptionImage: View {
    let image: EventDescriptionImageBlock

    var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: image.url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    EventDescriptionImagePlaceholder(systemImage: "photo.badge.exclamationmark")
                case .empty:
                    EventDescriptionImagePlaceholder(systemImage: "photo", showsProgress: true)
                @unknown default:
                    EventDescriptionImagePlaceholder(systemImage: "photo")
                }
            }
            .frame(width: proxy.size.width, height: 220)
            .clipShape(.rect(cornerRadius: 14, style: .continuous))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .accessibilityLabel(image.altText?.isEmpty == false ? image.altText! : "Event image")
    }
}

private struct EventDescriptionImagePlaceholder: View {
    let systemImage: String
    var showsProgress = false

    var body: some View {
        ZStack {
            AppTheme.softAccent

            if showsProgress {
                ProgressView()
            } else {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .foregroundStyle(AppTheme.accent)
            }
        }
    }
}

enum EventDescriptionBlock: Equatable {
    case text(String)
    case image(EventDescriptionImageBlock)
}

struct EventDescriptionImageBlock: Equatable {
    let url: URL
    let altText: String?
}

enum EventDescriptionParser {
    static func blocks(from description: String) -> [EventDescriptionBlock] {
        guard let imageTagRegex = try? NSRegularExpression(
            pattern: "<img\\b[^>]*>",
            options: [.caseInsensitive]
        ) else {
            return textBlocks(from: description)
        }

        let nsDescription = description as NSString
        let fullRange = NSRange(location: 0, length: nsDescription.length)
        let matches = imageTagRegex.matches(in: description, range: fullRange)

        guard !matches.isEmpty else {
            return textBlocks(from: description)
        }

        var blocks: [EventDescriptionBlock] = []
        var cursor = 0

        for match in matches {
            if match.range.location > cursor {
                appendText(
                    nsDescription.substring(with: NSRange(location: cursor, length: match.range.location - cursor)),
                    to: &blocks
                )
            }

            let tag = nsDescription.substring(with: match.range)
            if let image = imageBlock(fromImageTag: tag) {
                blocks.append(.image(image))
            }

            cursor = match.range.location + match.range.length
        }

        if cursor < nsDescription.length {
            appendText(
                nsDescription.substring(with: NSRange(location: cursor, length: nsDescription.length - cursor)),
                to: &blocks
            )
        }

        return blocks
    }

    private static func textBlocks(from text: String) -> [EventDescriptionBlock] {
        var blocks: [EventDescriptionBlock] = []
        appendText(text, to: &blocks)
        return blocks
    }

    private static func appendText(_ text: String, to blocks: inout [EventDescriptionBlock]) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            return
        }

        blocks.append(.text(trimmedText))
    }

    private static func imageBlock(fromImageTag tag: String) -> EventDescriptionImageBlock? {
        guard
            let src = attribute("src", in: tag),
            let url = URL(string: src)
                else {
            return nil
        }

        return EventDescriptionImageBlock(
            url: url,
            altText: attribute("alt", in: tag)
        )
    }

    private static func attribute(_ name: String, in tag: String) -> String? {
        let pattern = #"\b\#(name)\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s"'=<>`]+))"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            return nil
        }

        let nsTag = tag as NSString
        let match = regex.firstMatch(in: tag, range: NSRange(location: 0, length: nsTag.length))
        guard let match else {
            return nil
        }

        for index in 1..<match.numberOfRanges {
            let range = match.range(at: index)
            if range.location != NSNotFound {
                return nsTag.substring(with: range)
            }
        }

        return nil
    }
}

private struct EventDetailRow: View {
    let systemImage: String
    let title: String
    let value: String
    var accessorySystemImage: String?

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .foregroundStyle(AppTheme.accent)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
            }

            Spacer()

            if let accessorySystemImage {
                Image(systemName: accessorySystemImage)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    EventView(displayEvent: Mock.event)
}
// swiftlint:disable:this file_length
