//
//  HomeView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI
import Aurora

struct HomeView: View {
    // whether or not to show the Safari ViewController
    @State private var showSafari = false

    // initial URL string
    @State private var urlString = "https://appsterdam.rs"

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .trailing) {
                    Spacer().frame(maxWidth:.infinity)
                Button {
                    UIApplication.shared.openAppSettings()
                } label: {
                    Image(systemName: "gear")
                        .font(.system(.largeTitle))
                        .frame(width: 25, height: 25)

                }.padding(.trailing, 25)
                }.padding(.bottom, -25)

                Image(
                    "Appsterdam_logo",
                    bundle: nil,
                    label: Text("Appsterdam Logo")
                )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()

                Text("Appsterdam")
                    .font(.largeTitle)
                    .padding()

                if Bundle.main.isInTestFlight {
                    Text("""
                    ***TESTFLIGHT BUILD***
                    Please test:
                    - Events route
                    - Events general (landscape, portrait)
                    - Links/buttons in about
                    - Change Settings please button below
                    """)
                }
                Text(
                    .init("""
                **[Join the community](https://appsterdam.rs/join-community/)**
                We are 4,500 members of makers, designers and developers.
                App makers helping app makers -  come join our community!


                **[Collaborate](https://appsterdam.rs/collaborate/)**
                Do you have an SDK, API or plugin that you want to share with Appsterdamers?
                Contact us if you want to host a workshop or guru session.

                **[Share a project](https://appsterdam.rs/shared-projects/)**
                Our members are always developing new projects, products and solutions.
                Check out the projects they are most proud of here.
                """))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.leading, 5)
            }
        }
        // Safari
        .sheet(isPresented: $showSafari,
               content: {
            SafariView(url: $urlString)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
