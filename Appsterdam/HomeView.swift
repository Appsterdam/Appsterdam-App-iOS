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
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                Section("Community") {
                    ForEach(textSections, id: \.self) { element in
                        Text(.init(stringLiteral: String(element)))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .tint(.accentColor)
                            .padding(.vertical, 4)
                    }
                }
            }
            .appGroupedBackground()
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
                    .accessibilityLabel("Open Appsterdam settings")
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
        VStack(spacing: 16) {
            Image(
                "Appsterdam_logo",
                bundle: nil,
                label: Text("Appsterdam Logo")
            )
            .resizable()
            .scaledToFit()
            .frame(width: 104, height: 104)
            .padding(18)

            Text("Welcome to Appsterdam")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("The community for app makers in Amsterdam and beyond.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal)
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    HomeView()
}
