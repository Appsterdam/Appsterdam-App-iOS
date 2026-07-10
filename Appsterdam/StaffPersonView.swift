//
//  StaffPersonView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 15/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import SwiftUI
import SwiftExtras

struct StaffPersonView: View {
    let person: Person

    var body: some View {
        CardView(title: person.name, subtitle: person.function) {
            VStack(alignment: .center) {
                VStack {
                    if let picture = person.picture, !picture.isEmpty, let pictureURL = URL(string: picture) {
                        AsyncImage(
                            url: pictureURL) {
                                $0
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                            }

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
                    .foregroundStyle(Color.accentColor)
                    .onPortrait {
                        $0.padding(.top)
                    }

                HStack {
                    Spacer()

                    if let twitter = person.twitter, !twitter.isEmpty {
                        Button {
                            if let url = URL(string: "https://twitter.com/\(twitter)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Image("twitter")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 25, height: 25)
                        }
                    } else {
                        // Placeholder for design
                        Text("\u{3000}")
                    }

                    Spacer()

                    if let linkedin = person.linkedin, !linkedin.isEmpty {
                        Button {
                            if let url = URL(string: "https://linkedin.com/in/\(linkedin)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Image("linkedin")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 25, height: 25)
                        }
                    } else {
                        // Placeholder for design
                        Text("\u{3000}")
                    }

                    Spacer()

                    if let website = person.website, !website.isEmpty {
                        Button {
                            if let url = URL(string: website) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Image("globe")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.accentColor)
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

                GroupBox {
                    ScrollView {
                        Text(
                            .init(person.bio)
                        ).frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                    }
                }.padding()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct StaffPersonView_Previews: PreviewProvider {
    static var previews: some View {
        StaffPersonView(
            person: Mock.person
        )
    }
}
