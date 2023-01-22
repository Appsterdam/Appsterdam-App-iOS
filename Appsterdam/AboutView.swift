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

    // Show person view (profile)
    @State private var showPerson = false

    // initial URL string
    @State private var urlString = "https://appsterdam.rs"

    // Current person
    @State private var person: Person = Mock.person

    // Persons.
    @State private var persons = Model<AppModel>.init(
        url: "https://appsterdam.rs/api/app.json"
    ).Model?[0].people ?? Mock.app.people

    private var releaseVersionNumber: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("Appsterdam_logo", bundle: nil, label: Text("Appsterdam Logo"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                HStack {
                                    Image("Appsterdam_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)

                                    VStack {
                                        Text("Appsterdam")
                                            .font(.headline)

                                        Text("Version \(releaseVersionNumber)")
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }

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
                        if let persons = persons {
                            let _ = Aurora.shared.log(persons)

                            ForEach(persons) { team in
                                GroupBox.init(
                                    label: Text(team.team)) {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 20) {
                                                ForEach(team.members) { member in
                                                    personView(person: member)
                                                        .onTapGesture {
                                                            self.person = member
                                                            showPerson = true
                                                        }
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

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    }.padding(.top)
                    Divider()
                    Button("Facebook") {
                        self.urlString = "https://www.facebook.com/appsterdam"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Divider()
                    Button("Twitter") {
                        self.urlString = "https://www.twitter.com/appsterdam"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Divider()
                    Button("YouTube") {
                        self.urlString = "https://www.youtube.com/appsterdam"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    }.padding(.bottom)
                }

                VStack {
                    Button("Website") {
                        self.urlString = "https://appsterdam.rs/"

                        showSafari = true
                    }.padding(.top)
                    Divider()

                    Button("Code of Conduct") {
                        self.urlString = "https://appsterdam.rs/code-of-conduct/"

                        showSafari = true
                    }
                    Divider()

                    Button("Privacy Policy") {
                        self.urlString = "https://appsterdam.rs/privacy-policy/"

                        showSafari = true
                    }
                }

                Text("© 2012-2023 Stichting Appsterdam. All rights reserved")
                    .font(.caption)
                    .padding()
            }
            .sheet(isPresented: $showPerson,
                   content: {
                StaffPersonView(person: $person)
            })
            .sheet(isPresented: $showSafari,
                   content: {
                SafariView(url: $urlString)
            })
            .onAppear {
                DispatchQueue.global(qos: .background).async {
                    if let ModelValue = Model<AppModel>.init(
                        url: "https://appsterdam.rs/api/app.json"
                    ).update(),
                       ModelValue.count > 0 {
                        self.persons = ModelValue[0].people
                    }
                }
            }
        }.navigationViewStyle(.stack)
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
            if let picture = person.picture, picture.count > 0 {
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

            Text(.init(person.name))
                .foregroundColor(Color.accentColor)

            Text(.init(person.function))
                .font(.caption)
        }
    }
}

// MARK: Preview
struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            personView(person: Mock.person)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
        .previewDisplayName("PersonView")
    }
}

struct Cell: View {
    let text: String

    var body: some View {
        Text(.init(text))
    }
}
