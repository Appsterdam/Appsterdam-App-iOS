//
//  EventView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 25/01/2022.
//

import SwiftUI
import MapKit
import SwiftExtras

struct myAnnotation: Identifiable {
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
        CardView(title: displayEvent.name) {
            VStack(alignment: .center) {
                if sizeClass == .regular {
                    let url = URL(
                        string: "https://appsterdam.rs/api/getImage.php?eid=\(displayEvent.id)&for=\(displayEvent.name.urlEncoded)"
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
                    Text(
                        "Date: \(dateFormat().convert(jsonDate: String(displayEvent.date.split(separator: ":")[0])))"
                    )

                    if (displayEvent.location_name.contains("http")) {
                        Text("Online event")
                    } else {
                        Text("Location: \(displayEvent.location_name) 📍").onTapGesture {
                            if displayEvent.location_name.contains("online") {
                                return
                            }

                            if displayEvent.latitude == "0" &&
                                displayEvent.longitude == "0" {
                                guard let url = URL(string: "http://maps.apple.com/?daddr=\(displayEvent.latitude),\(displayEvent.longitude)") else { return }

                                UIApplication.shared.open(url)
                            } else {
                                guard let url = URL(string: "http://maps.apple.com/?daddr=\(displayEvent.location_address.urlEncoded),Netherlands") else { return }
                                print(displayEvent.location_address)
                                print(url)
                                UIApplication.shared.open(url)
                            }

                        }
                    }
                    Text("Attendees: \(displayEvent.attendees)")
                }
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

                GroupBox() {
                    Button ("\(AttendOrView(date:displayEvent.date)) \(displayEvent.name)") {
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

    func AttendOrView(date: String) -> String {
        let split = date.split(separator: ":")
        let eventDate = split[0]

        let df = DateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"

        if df.string(from: Date()) > eventDate {
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
