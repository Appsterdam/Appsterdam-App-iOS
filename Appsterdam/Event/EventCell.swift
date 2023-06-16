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
                    Text(dateFormat().convert(jsonDate: event.date))
                        .font(.caption)

                    Spacer()

                    Image(systemName: "person.fill.checkmark")
                    Text(.init(event.attendees))
                        .font(.caption)
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
