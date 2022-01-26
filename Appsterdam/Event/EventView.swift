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

    // whether or not to show the Safari ViewController
    @State var showSafari = false
    // initial URL string
    @State var urlString = "https://appsterdam.rs"

    @Binding var displayEvent: Event

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 51.507222,
            longitude: -0.1275
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1
        )
    )

    var body: some View {
        VStack {
            VStack {
                GroupBox() {
                    HStack() {
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

                    Text(displayEvent.name)

                    Text("Date: xxxx")
                    Text("Time: xxxx")

                    Divider()

                    ScrollView {
                        Text(displayEvent.description)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }

                    let _ = updateMap()
                    Map(coordinateRegion: $region, annotationItems: [
                        myAnnotation.init(name: displayEvent.name, coordinate: CLLocationCoordinate2D(latitude: displayEvent.latitude, longitude: displayEvent.longitude))
                    ]) { item in
                        MapPin(coordinate: item.coordinate)

                    }
                        .frame(width: 400, height: 200)
                }
            }
            GroupBox() {
                Button ("Attend \(displayEvent.name)") {
                    self.urlString = "https://www.meetup.com/nl-NL/Appsterdam/events/280861388/"

                    showSafari = true
                }
            }
            .popover(isPresented: $showSafari,  content: {
                SafariView(urlString: $urlString)
            })
        }
    }

    func updateMap() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(displayEvent.address) {
            (placemarks, error) in
            guard error == nil,
            let coordinate = placemarks?.first?.location?.coordinate else {
                let _ = print("Geocoding error: \(error!)")

                return
            }

            self.region = .init(
                center: coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )
        }
    }
}


struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(
            displayEvent: .constant(
                .init(
                    id: "0",
                    name: "Test event",
                    description: "Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, Super description, ",
                    price: 0,
                    organizer: "Appsterdam",
                    location: "",
                    address: "",
                    latitude: 52.3655891418457,
                    longitude: 4.867978096008301,
                    date: "",
                    attendees: 25,
                    icon: "star"
                )
            )
        )

        EventView(
            displayEvent: .constant(
                .init(
                    id: "",
                    name: "Test event, with beer involved.",
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
                    price: 0,
                    organizer: "Appsterdam",
                    location: "Cafe Bax",
                    address: "Kinkerstraat 119, 1053CC, Amsterdam",
                    latitude: 52.3655891418457,
                    longitude: 4.867978096008301,
                    date: "",
                    attendees: 25,
                    icon: "🍺"
                )
            )
        )
    }
}
