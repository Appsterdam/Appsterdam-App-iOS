//
//  EventView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 25/01/2022.
//

import SwiftUI
import MapKit

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
                        Text("Date: \(convertDateFormat(inputDate: displayEvent.date.split(":")[0]))")
                        Text("Location:  \(displayEvent.location_name) 📍").onTapGesture {
                            if displayEvent.location_name.contains("online") {
                                return
                            }

                            guard let url = URL(string: "http://maps.apple.com/?daddr=\(displayEvent.latitude),\(displayEvent.longitude)") else { return }
                            UIApplication.shared.open(url)
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

                    showSafari = true
                }
            }
            .popover(isPresented: $showSafari,  content: {
                SafariView(urlString: $urlString)
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

    func convertDateFormat(inputDate: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let oldDateTime = dateFormatter.date(
            from: inputDate
        )

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        convertDateFormatter.locale = Locale.current

        return convertDateFormatter.string(
            from: oldDateTime!
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
    }
}
