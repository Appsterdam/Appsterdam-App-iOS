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
    // initial URL string
    @State private var urlString = "https://appsterdam.rs"

    // Current person
    @State private var selectedPerson: Person?

    // Persons.
    @StateObject private var persons = Model<AppModel>.init(
        url: "https://appsterdam.rs/api/app.json"
    )

    private var releaseVersionNumber: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    AboutHeroCard(version: releaseVersionNumber)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image("Appsterdam_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .accessibilityHidden(true)

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
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    ForEach(team.members) { member in
                                        Button {
                                            selectedPerson = member
                                        } label: {
                                            PersonView(person: member)
                                        }
                                        .buttonStyle(.plain)
                                        .accessibilityLabel("\(member.name), \(member.function)")
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .scrollIndicators(.hidden)
                        }
                    }
                } else {
                    ProgressView()
                        .controlSize(.large)
                }

                Section("Socials") {
                    Button {
                        self.urlString = "https://discord.gg/HNqZPUy7An"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Discord", systemImage: "bubble.left.and.bubble.right")
                    }

                    Button {
                        self.urlString = "https://www.facebook.com/appsterdam"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Facebook", systemImage: "person.3")
                    }

                    Button {
                        self.urlString = "https://www.twitter.com/appsterdam"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Twitter", systemImage: "bubble")
                    }

                    Button {
                        self.urlString = "https://www.youtube.com/appsterdam"

                        if let url = URL(string: self.urlString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("YouTube", systemImage: "play.rectangle")
                    }
                }

                Section("More") {
                    Button {
                        self.urlString = "https://appsterdam.rs/"
                        showSafari = true
                    } label: {
                        Label("Website", systemImage: "globe")
                    }

                    Button {
                        self.urlString = "https://appsterdam.rs/code-of-conduct/"
                        showSafari = true
                    } label: {
                        Label("Code of Conduct", systemImage: "checkmark.shield")
                    }

                    Button {
                        self.urlString = "https://appsterdam.rs/privacy-policy/"
                        showSafari = true
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                }

                Text("© 2011-\(String(Date.now.year)) Stichting Appsterdam.\r\nAll rights reserved")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .listRowBackground(Color.clear)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .appGroupedBackground()
            .refreshable {
                await persons.update()
            }
            .sheet(item: $selectedPerson, content: StaffPersonView.init)
            .sheet(isPresented: $showSafari) {
                SafariView(url: $urlString)
            }
        }
    }
}

private struct AboutHeroCard: View {
    let version: String

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 14) {
                Image("Appsterdam_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 58, height: 58)
                    .padding(10)
                    .background(.regularMaterial, in: Circle())
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Appsterdam")
                        .font(.title2.bold())

                    Text("Version \(version)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "quote.opening")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)

                // swiftlint:disable:next line_length
                Text("If you want to make movies, go to Hollywood. If you want to make musicals, go to Broadway. If you want to make apps, go to Appsterdam.")
                    .font(.headline)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Mike Lee")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppTheme.cardBackground)
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(AppTheme.softAccent)
                        .frame(width: 128, height: 128)
                        .offset(x: 38, y: -44)
                }
                .overlay(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(AppTheme.accent)
                        .frame(width: 54, height: 6)
                        .padding(20)
                }
        }
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
        .padding(.horizontal)
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
        // swiftlint:disable:next line_length
        .accessibilityLabel("Appsterdam, version \(version). Quote by Mike Lee: If you want to make movies, go to Hollywood. If you want to make musicals, go to Broadway. If you want to make apps, go to Appsterdam.")
    }
}

// MARK: Preview
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .previewDisplayName("Default preview")
    }
}

// MARK: - PersonView
// MARK: View
struct PersonView: View {
    let person: Person

    var body: some View {
        VStack(spacing: 8) {
            if let picture = person.picture, !picture.isEmpty, let pictureURL = URL(string: picture) {
                AsyncImage(
                    url: pictureURL
                ) {
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
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
            }

            Text(.init(person.name))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)

            Text(.init(person.function))
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(width: 132)
        .padding(10)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
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
