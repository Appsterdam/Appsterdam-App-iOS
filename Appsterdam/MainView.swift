//
//  MainView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI

enum AppTheme {
    static let accent = Color.accentColor
    static let background = LinearGradient(
        colors: [
            Color(uiColor: .systemGroupedBackground),
            Color.accentColor.opacity(0.08),
            Color(uiColor: .systemBackground)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let cardBackground = Color(uiColor: .secondarySystemGroupedBackground)
    static let softAccent = Color.accentColor.opacity(0.12)
}

extension View {
    func appGroupedBackground() -> some View {
        scrollContentBackground(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 8)
            }
    }
}

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            EventListView()
                .tabItem {
                    Label("Events", systemImage: "person.3.fill")
                }

            if Settings.shared.jobsEnable {
                JobsView()
                    .tabItem {
                        Label("Jobs", systemImage: "signature")
                    }
            }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle.fill")
                }
        }
        .tint(AppTheme.accent)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
