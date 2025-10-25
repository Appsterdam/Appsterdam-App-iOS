//
//  HomeView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI
import SwiftExtras

struct HomeView: View {
    // whether or not to show the Safari ViewController
    @State private var showSafari = false

    // initial URL string
    @State private var urlString = "https://appsterdam.rs"

    @ObservedObject private var app = Model<AppModel>.init(
        url: "https://appsterdam.rs/api/app.json"
    )

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image(
                        "Appsterdam_logo",
                        bundle: nil,
                        label: Text("Appsterdam Logo")
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
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
                                }
                            }
                        }

                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                guard let url = URL(
                                    string: UIApplication.openSettingsURLString
                                ) else {
                                    return
                                }
                                openURL(url)
                            } label: {
                                Image(systemName: "gear")
                                    .font(.system(.title2))
                            }
                        }
                    }

                    Text("Appsterdam")
                        .font(.largeTitle)
                        .padding()

                    GroupBox {
                        Text(.init(app.model?.first?.home ?? Mock.app.home))
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .tint(Color.accent)
                            .padding(.leading, 5)
                    }
                }
            }
            .refreshable {
                Task.detached {
                    await app.update()
                }
            }
            .sheet(isPresented: $showSafari) {
                SafariView(url: $urlString)
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
