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
        CardView(title: displayEvent.name) {
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
            }.onLandscape {
                $0.frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            }

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
        }
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
