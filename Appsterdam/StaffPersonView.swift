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
    @Environment(\.verticalSizeClass) var sizeClass

    var body: some View {
        CardView(title: person.name) {
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
                    )
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                }
            }.onPortrait {
                $0.frame(width: 200, height: 200)
            }
            .onLandscape {
                $0.frame(width: 100, height: 100)
            }

            Text(.init(person.function))
                .foregroundColor(Color.accentColor)
                .onPortrait {
                    $0.padding(.top)
                }

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
            }.onPortrait {
                $0.padding()
            }

            ScrollView {
                // BIO
                Text(.init(person.bio))
            }
        }
    }
}

struct StaffPersonView_Previews: PreviewProvider {
    static var previews: some View {
        StaffPersonView(person: .constant(Mock.person))
    }
}
