//
//  EventCell.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 23/01/2022.
//  Copyright © 2022 Appsterdam. All rights reserved.
//

import SwiftUI

struct EventCell: View {
    var event: event

    var body: some View {
        HStack {
            if event.image.count > 2 {
                Image(systemName: event.image)
            } else {
                if let image = event.image.emojiToImage {
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
        EventCell(event: .init(name: "preview", description: "preview string", date: .init(), attendees: 2, image: "star"))
    }
}
