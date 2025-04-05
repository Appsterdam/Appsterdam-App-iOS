//
//  EventView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 25/01/2022.
//

import SwiftUI
import MapKit
import SwiftExtras

struct MyAnnotation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct EventView: View {
    // To dismiss this screen using the button.
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.verticalSizeClass) var sizeClass

    @Binding var displayEvent: Event

    var body: some View {
        CardView(
            title: displayEvent.name,
            subtitle: displayEvent.location_name
        ) {
            VStack(alignment: .center) {
                if sizeClass == .regular {
                    let url = URL(
                        string: "https://appsterdam.rs/api/getImage.php?eid=\(displayEvent.id)&for=\(displayEvent.name.urlEncoded)"
                        // swiftlint:disable:previous line_length
                    )!

                    AsyncImage(
                        url: url,
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
                        value: "\(DateFormat().convert(jsonDate: String(displayEvent.date.split(separator: ":")[0])))"
                    )

                    if displayEvent.location_name.contains("http") {
                        Text("Online event")
                    } else {
                        HStack {
                            LabeledContent("Location:", value: displayEvent.location_name)
                            Image(systemName: "arrow.up.right.diamond")
                                .foregroundStyle(.accent)

                        }
                        .onTapGesture {
                            if displayEvent.location_name.contains("online") {
                                return
                            }

                            guard let url = URL(
                                string: "http://maps.apple.com/?daddr=\(displayEvent.location_address.urlEncoded),Netherlands"
                                // swiftlint:disable:previous line_length
                            ) else { return }
                            print(displayEvent.location_address)
                            print(url)
                            UIApplication.shared.open(url)
                        }
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
                    Button("\(attendOrView(date: displayEvent.date)) \(displayEvent.name)") {
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

    func attendOrView(date: String) -> String {
        let split = date.split(separator: ":")
        let eventDate = split[0]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"

        if dateFormatter.string(from: Date()) > eventDate {
            return "View"
        }

        return "Attend"
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(displayEvent: .constant(Mock.event))

        if #available(iOS 15.0, *) {
            EventView(
                displayEvent: .constant(Mock.event)
            )
            .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
