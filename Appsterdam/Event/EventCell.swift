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
        HStack {
            // Event icon
            if Settings.shared.eventsShowIcon {
                VStack {
                    if event.icon.count > 2 {
                        // 30wx35h
                        Image(
                            systemName: event.icon
                        )
                    } else {
                        if let image = event.icon.emojiToImage {
                            Image.init(
                                uiImage: image
                            )
                                .resizable()
                        }
                    }
                }
                .frame(width: 30, height: 30)
            }

            VStack {
                Text(.init(event.name))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(.init(
                    Settings.shared.eventsDescription
                    ? event.description
                    : ""
                ))
                    .font(.caption)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    // Date/time
                    Image(systemName: "calendar.badge.clock")

                    Text(
                        dateFormat().convert(
                            jsonDate: event.date
                        )
                    ).font(.caption)

                    Spacer()

                    //                    // Attendees
                    Image(systemName: "person.fill.checkmark")
                    Text(.init(event.attendees))
                        .font(.caption)
                    Spacer()

                    // Place
                    Image(systemName: "mappin.and.ellipse")
                    Text(.init(
                        event.location_name
                            .contains(search: "http")
                        ? "Online event"
                        : event.location_name
                    ))
                        .font(.caption)
                    Spacer()
                }
            }
        }
    }
}

struct EventCell_Previews: PreviewProvider {
    static var previews: some View {
        EventCell(event: Mock.event)
    }
}
