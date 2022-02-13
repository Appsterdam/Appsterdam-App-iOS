//
//  AboutView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI
import Aurora

// MARK: - AboutView
// MARK: View
struct AboutView: View {
    // whether or not to show the Safari ViewController
    @State private var showSafari = false
    
    // initial URL string
    @State private var urlString = "https://appsterdam.rs"

    private let persons = Model<PersonModel>.init(
        url: "https://appsterdam.rs/api/people.json"
    ).load()

    private var releaseVersionNumber: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var body: some View {
        ScrollView {
            VStack {
                Image("Appsterdam_logo", bundle: nil, label: Text("Appsterdam Logo"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                Text("Appsterdam")
                    .font(.title)
                    .bold()
                Text("Version \(releaseVersionNumber)")
                    .font(.title3)
                    .padding(.bottom)

                Text("“If you want to make movies, go to Hollywood.\nIf you want to make musicals, go to Broadway.\nIf you want to make apps, go to Appsterdam.”")

                Text("- Mike Lee\u{3000}")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom)

                Text("Appsterdam Team")
                    .font(.title)
                    .padding(.top)


                VStack(spacing: 20) {
                    let _ = Aurora.shared.log(persons)

                    ForEach(persons) { team in
                        GroupBox.init(
                            label: Text(team.team)) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(team.members) { member in
                                            personView(person: member)
                                                .onTapGesture {
                                                    self.urlString = "https://appsterdam.rs/team-\(member.name.lowercased().replace(" ", withString: "-"))/"

                                                    showSafari = true
                                                }
                                        }
                                    }
                                }
                            }
                    }
                }
            }.padding(.bottom)

            VStack {
                Button("Discord") {
                    self.urlString = "https://discord.gg/HNqZPUy7An"

                    showSafari = true
                }.padding(.top)
                Divider()
                Button("Facebook") {
                    self.urlString = "https://www.facebook.com/appsterdam"

                    showSafari = true
                }
                Divider()
                Button("Twitter") {
                    self.urlString = "https://www.twitter.com/appsterdam"

                    showSafari = true
                }
                Divider()
                Button("YouTube") {
                    self.urlString = "https://www.youtube.com/appsterdam"

                    showSafari = true
                }.padding(.bottom)

                Button("Code of Conduct") {
                    self.urlString = "https://appsterdam.rs/code-of-conduct/"

                    showSafari = true
                }.padding(.top)
                Divider()

                Button("Privacy Policy") {
                    self.urlString = "https://appsterdam.rs/privacy-policy/"

                    showSafari = true
                }
            }

            Text("© 2012-2022 Stichting Appsterdam. All rights reserved")
                .font(.caption)
                .padding()
        }
        .sheet(isPresented: $showSafari,
               content: {
            SafariView(url: $urlString)
        })
    }
}

// MARK: Preview
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .previewDisplayName("Default preview")
    }
}

// MARK: - PersonView
// MARK: View
struct personView: View {
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
                ).frame(width: 100, height: 100)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
            }

            Text(person.name)
                .foregroundColor(Color.accentColor)

            Text(person.function)
                .font(.caption)
        }
    }
}

// MARK: Preview
struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            personView(person: .init(
                name: "Appsterdam",
                picture: nil,
                function: "Test")
            )
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
        .previewDisplayName("PersonView")
    }
}

struct Cell: View {
    let text: String

    var body: some View {
        Text(text)
    }
}
