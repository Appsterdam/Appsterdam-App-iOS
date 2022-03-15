//
//  StaffPersonView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 15/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import SwiftUI
import Aurora

struct StaffPersonView: View {
    let person: Person

    var body: some View {
        VStack {
            if let picture = person.picture, picture.length > 0 {
                // picture
                RemoteImageView(
                    url: URL(string: picture)!,
                    placeholder: {
                        Image(systemName: "person.circle")
                    },
                    image: {
                        $0.resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    }
                ).frame(width: 200, height: 200)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 200, height: 200)
            }

            Text(person.name)
                .foregroundColor(Color.accentColor)

            Text(person.function)
                .font(.caption)

            // Socials
            // Twitter
            // Linkedin
            // Website

            // BIO
            Text(person.bio)
        }
    }
}

struct StaffPersonView_Previews: PreviewProvider {
    static var previews: some View {
        StaffPersonView(
            person: .init(name: "Wesley", picture: nil, function: "App Builder", twitter: "wesdegroot", linkedin: "wesdegroot", website: "https://wesleydegroot.nl", bio: "Hi!")
        )
    }
}
