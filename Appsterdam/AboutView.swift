//
//  AboutView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI
import Aurora

// MARK: - View
struct AboutView: View {
    // whether or not to show the Safari ViewController
    @State var showSafari = false
    // initial URL string
    @State var urlString = "https://appsterdam.rs"

    let persons = PersonModel().load()

    var releaseVersionNumber: String {
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
                    .bold()
                Text("Version \(releaseVersionNumber)")
                    .padding(.bottom)

                Text("“If you want to make movies, go to Hollywood.\nIf you want to make musicals, go to Broadway.\nIf you want to make apps, go to Appsterdam.”")
                Text("- Mike Lee ")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom)

                Text("Appsterdam Team")
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        let _ = print(persons)

                        ForEach(persons) { person in
                            VStack {
                                personView(person: person)
                                    .onTapGesture {
                                        self.urlString = "https://appsterdam.rs/team-\(person.name.lowercased().replace(" ", withString: "-"))/"

                                        showSafari = true
                                    }
                            }
                        }
                    }
                }.padding(.bottom)

                HStack {
                    Button("Code of Conduct") {
                        self.urlString = "https://appsterdam.rs/code-of-conduct/"

                        showSafari = true
                    }
                    .padding()

                    Button("Privacy Policy") {
                        self.urlString = "https://appsterdam.rs/privacy-policy/"

                        showSafari = true
                    }
                    .padding()
                }.padding(.top)

                Text("© 2012-2022 Stichting Appsterdam. All rights reserved")
                    .font(.caption)
                    .padding()
            }
            .popover(isPresented: $showSafari, content: {
                SafariView(urlString: $urlString)
            })
        }
    }
}

// MARK: - Preview
struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
            .previewDisplayName("Default preview")
    }
}

struct personView: View {
    let person: Person

    var body: some View {
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

