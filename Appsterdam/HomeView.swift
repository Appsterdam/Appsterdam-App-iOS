//
//  HomeView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var app = Model<AppModel>.init(
        url: "https://appsterdam.rs/api/app.json"
    )

    var textSections: [Substring] {
        let text = app.model?.home ?? Mock.app.home
        return text.split(separator: "\r\n\r\n")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HomeWelcomeHeader()
                }

                Section("Community") {
                    ForEach(textSections, id: \.self) { element in
                        Text(.init(stringLiteral: String(element)))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .tint(.accentColor)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        guard let url = URL(
                            string: UIApplication.openSettingsURLString
                        ) else {
                            return
                        }
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .refreshable {
                await app.update()
            }
        }
    }
}

private struct HomeWelcomeHeader: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(
                "Appsterdam_logo",
                bundle: nil,
                label: Text("Appsterdam Logo")
            )
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)

            Text("Welcome to Appsterdam")
                .font(.title2)
                .fontWeight(.semibold)

            Text("The community for app makers in Amsterdam and beyond.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}

#Preview {
    HomeView()
}
