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
            if event.icon.count > 2 {
                Image(systemName: event.icon)
            } else {
                if let image = event.icon.emojiToImage {
                    Image.init(
                        uiImage: image
                    )
                } else {
                    Image(systemName: "person.3.fill")
                }
            }

            VStack {
                Text(event.name)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(event.description)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
struct EventCell_Previews: PreviewProvider {
    static var previews: some View {
        EventCell(event:
                        .init(
                            id: "0",
                            name: "preview",
                            description: "preview string",
                            price: 0,
                            organizer: "Appsterdam",
                            location: "Cafe Bax",
                            address: "Kinkerstraat 119, 1053CC Amsterdam, Netherlands",
                            latitude: 52.3655891418457,
                            longitude: 4.867978096008301,
                            date: "",
                            attendees: 2,
                            icon: "star")
        )
    }
}
