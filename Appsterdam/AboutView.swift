//
//  AboutView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI
import SwiftExtras

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
    @ObservedObject private var persons = Model<AppModel>.init(
        url: "https://appsterdam.rs/api/app.json"
    )

    private var releaseVersionNumber: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var body: some View {
        NavigationView {
            Form {
                // swiftlint:disable:next line_length
                VStack {
                    Group {
                        Text("“If you want to make movies, go to Hollywood.")
                        Text("If you want to make musicals, go to Broadway.")
                        Text("If you want to make apps, go to Appsterdam.”")
                    }
                    .frame(maxWidth: .infinity)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))

                Text("- Mike Lee\u{3000}")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .listRowInsets(EdgeInsets(top: -10, leading: 0, bottom: 10, trailing: 0))
                    .listRowBackground(Color.clear)
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

                if let model = persons.model {
                    ForEach(model.people) { team in
                        Section(team.team) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(team.members) { member in
                                        PersonView(person: member)
                                            .onTapGesture {
                                                self.person = member
                                                showPerson = true
                                            }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ProgressView()
                        .controlSize(.large)
                }

                Section("Socials") {
                    Button("Discord") {
                        self.urlString = "https://discord.gg/HNqZPUy7An"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    }

                    Button("Facebook") {
                        self.urlString = "https://www.facebook.com/appsterdam"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    }

                    Button("Twitter") {
                        self.urlString = "https://www.twitter.com/appsterdam"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    }

                    Button("YouTube") {
                        self.urlString = "https://www.youtube.com/appsterdam"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }

                Section {
                    Button("Website") {
                        self.urlString = "https://appsterdam.rs/"
                        showSafari = true
                    }

                    Button("Code of Conduct") {
                        self.urlString = "https://appsterdam.rs/code-of-conduct/"
                        showSafari = true
                    }

                    Button("Privacy Policy") {
                        self.urlString = "https://appsterdam.rs/privacy-policy/"
                        showSafari = true
                    }
                }

                Text("© 2011-\(String(Date.now.year)) Stichting Appsterdam.\r\nAll rights reserved")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .listRowBackground(Color.clear)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .refreshable {
                Task {
                    await persons.update()
                }
            }
            .onChange(of: persons.model?.people.first?.team.count) { _ in
                print("Model did change!!!")
            }
            .sheet(isPresented: $showPerson) {
                StaffPersonView(person: $person)
            }
            .sheet(isPresented: $showSafari) {
                SafariView(url: $urlString)
            }
        }
        .navigationViewStyle(.stack)
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
struct PersonView: View {
    let person: Person

    var body: some View {
        VStack {
            if let picture = person.picture, picture.count > 0 {
                AsyncImage(
                    url: URL(string: picture)!) {
                        $0
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                    }
                    .frame(width: 100, height: 100)
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
            PersonView(person: Mock.person)
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
        .previewDisplayName("PersonView")
    }
}
