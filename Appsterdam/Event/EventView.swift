//
//  EventView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 25/01/2022.
//

import SwiftUI
import SwiftExtras

struct EventView: View {
    @Environment(\.verticalSizeClass) private var sizeClass

    let displayEvent: Event

    var body: some View {
        CardView(
            title: displayEvent.name,
            subtitle: displayEvent.locationName
        ) {
            VStack(alignment: .center) {
                if sizeClass == .regular, let imageURL {
                    AsyncImage(
                        url: imageURL,
                        content: {
                            $0.resizable()
                        }, placeholder: {
                            ProgressView()
                                .controlSize(.large)
                        }
                    )
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: 250
                    )
                }

                VStack {
                    LabeledContent(
                        "Date:",
                        value: EventDateFormatter.string(from: displayEvent.date)
                    )

                    if isOnlineEvent {
                        Text("Online event")
                    } else if let mapsURL {
                        Button {
                            UIApplication.shared.open(mapsURL)
                        } label: {
                            HStack {
                                LabeledContent("Location:", value: displayEvent.locationName)
                                Image(systemName: "arrow.up.right.diamond")
                                    .foregroundStyle(.accent)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    LabeledContent("Organised by:", value: displayEvent.organizer)
                    LabeledContent("Attendees:", value: displayEvent.attendees)
                }
                .padding()
                .frame(maxWidth: .infinity)

                GroupBox {
                    ScrollView {
                        Text(
                            // Init to enable Markdown
                            .init(
                                displayEvent.description
                            )
                        )
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    }
                }.padding()

                GroupBox {
                    Button("\(attendanceAction) \(displayEvent.name)") {
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
            }
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
        return components?.url
    }

    private var mapsURL: URL? {
        var components = URLComponents(string: "https://maps.apple.com/")
        components?.queryItems = [
            URLQueryItem(name: "daddr", value: "\(displayEvent.locationAddress),Netherlands")
        ]
        return components?.url
    }
}

#Preview {
    EventView(displayEvent: Mock.event)
}
