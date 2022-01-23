//
//  AboutView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI

// MARK: - View
struct AboutView: View {
    var body: some View {
        VStack {
            Image("Appsterdam_logo", bundle: nil, label: Text("Appsterdam Logo"))
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

            Text("Appsterdam")
                .bold()
            Text("Version 1.0")
                .padding(.bottom)

            Text("“If you want to make movies, go to Hollywood.\nIf you want to make musicals, go to Broadway.\nIf you want to make apps, go to Appsterdam.”")
            Text("- Mike Lee ")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom)

            Text("Appsterdam Team")
                .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<10) { person in
                        VStack {
                            Image(systemName: "star")
                                .resizable()
                                .frame(width: 100, height: 100)

                            Text("Person \(person)")
                        }
                    }
                }
            }

            Button("Code of Conduct") {
                if let url = URL(string: "https://appsterdam.rs/code-of-conduct/") {
                    UIApplication.shared.open(url)
                }
            }.padding()

            Button("Privacy Policy") {
                if let url = URL(string: "https://appsterdam.rs/privacy-policy/") {
                    UIApplication.shared.open(url)
                }
            }.padding()

            Text("© 2012-2022 Stichting Appsterdam. All rights reserved").padding()
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

// MARK: - Data structures
struct personModel: Identifiable {
    var id: ObjectIdentifier
    let name: String
    let photo: String
}

//struct personView: View {
//    let person: personModel
//
//    var body: some View {
//
//    }
//}

