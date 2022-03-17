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
    @Binding var person: Person

    var body: some View {
        CardView(title: person.name) {
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

            Text(person.function)
                .foregroundColor(Color.accentColor)
                .padding(.top)

            HStack {
                Spacer()

                if !person.twitter.isEmpty {
                    Button {
                        if let url = URL(string: "https://twitter.com/\(person.twitter)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Image("twitter")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.accentColor)
                            .frame(width: 25, height: 25)
                    }
                } else {
                    // Placeholder for design
                    Text("\u{3000}")
                }

                Spacer()

                if !person.linkedin.isEmpty {
                    Button {
                        if let url = URL(string: "https://linkedin.com/in/\(person.twitter)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Image("linkedin")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.accentColor)
                            .frame(width: 25, height: 25)
                    }
                } else {
                    // Placeholder for design
                    Text("\u{3000}")
                }

                Spacer()

                if !person.website.isEmpty {
                    Button {
                        if let url = URL(string: person.website) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Image("globe")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.accentColor)
                            .frame(width: 25, height: 25)
                    }
                } else {
                    // Placeholder for design
                    Text("\u{3000}")
                }

                Spacer()
            }.padding()
            ScrollView {
                // BIO
                Text(person.bio)
            }
        }
    }
}

struct StaffPersonView_Previews: PreviewProvider {
    static var previews: some View {
        StaffPersonView(person: .constant(Mock.person))
    }
}
