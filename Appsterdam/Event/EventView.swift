//
//  EventView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 25/01/2022.
//

import SwiftUI
import MapKit
import Aurora

struct myAnnotation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct EventView: View {
    // To dismiss this screen using the button.
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.verticalSizeClass) var sizeClass

    // whether or not to show the Safari ViewController
    @State var showSafari = false
    // initial URL string
    @State var urlString = "https://appsterdam.rs"

    @Binding var displayEvent: Event

    var body: some View {
        VStack {
            VStack {
                GroupBox() {
                    HStack() {
                        Text(displayEvent.name)
                            .font(.title)
                            .lineLimit(1)

                        // To make it on the right
                        Spacer()

                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "xmark")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(.secondary)
                                )
                        }).padding(5)
                    }

                    if sizeClass == .regular {
                        if displayEvent.icon.count > 2 {
                            Image(systemName: displayEvent.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        } else {
                            if let image = displayEvent.icon.emojiToImage {
                                Image.init(
                                    uiImage: image
                                ).resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            } else {
                                Image(systemName: "star")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            }
                        }
                    }

                    VStack {
                        Text("Date: \(dateFormat().convert(jsonDate: displayEvent.date.split(":")[0]))")

                        if (displayEvent.location_name.contains(search: "http")) {
                            Text("Online event")
                        } else {
                            Text("Location:  \(displayEvent.location_name) 📍").onTapGesture {
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
                    }.onLandscape {
                        $0.frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    }

                    Divider()

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
                }
            }
            GroupBox() {
                Button ("Attend \(displayEvent.name)") {
                    self.urlString = "https://www.meetup.com/nl-NL/Appsterdam/events/\(displayEvent.id)/"

                    if Settings.shared.eventsOpenInApp {
                        showSafari = true
                    } else {
                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSafari, content: {
                SafariView(url: $urlString)
            })
        }.gesture(
            DragGesture(
                minimumDistance: 20,
                coordinateSpace: .local
            )
                .onEnded({ value in
                    if value.translation.height > 0 {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
        )
    }
}


struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(
            displayEvent: .constant(
                .init(
                    id: "0",
                    name: "Weekend fun: ARTIS/NEMO",
                    description: "Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, ",
                    price: "0",
                    organizer: "Appsterdam",
                    location_name: "",
                    location_address: "",
                    date: "",
                    attendees: "25",
                    icon: "star",
                    latitude: "",
                    longitude: ""
                )
            )
        )

        if #available(iOS 15.0, *) {
            EventView(
                displayEvent: .constant(
                    .init(
                        id: "",
                        name: "Weekly Meeten en Drinken",
                        description: """
                    What shall we drink
                    Seven days long
                    What shall we drink?
                    What a thirst!

                    There's plenty for everyone
                    So we'll drink together
                    So just dip into the cask!
                    Yes, let's drink together
                    Not alone!

                    And then we shall work
                    Seven days long!
                    Then we shall work
                    For each other!

                    Then there will be work for everyone
                    So we shall work together
                    Seven days long!
                    Yes, we'll work together
                    Not alone!

                    But first we have to fight
                    Nobody knows for how long!
                    First we have to fight
                    For our interest!

                    For everybody's happiness
                    So we'll fight together
                    Together we're strong!
                    Yes, we'll fight together
                    Not alone!
                    """,
                        price: "0",
                        organizer: "Appsterdam",
                        location_name: "Cafe Bax",
                        location_address: "Kinkerstraat 119, 1053CC, Amsterdam",
                        date: "",
                        attendees: "25",
                        icon: "🍺",
                        latitude: "",
                        longitude: ""
                    )
                )
            )
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}
