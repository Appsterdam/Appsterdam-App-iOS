//
//  MainView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI

struct MainView: View {
    @State var animate = false
    @State var showSplash = true

    @State var selectedTab: Int = 0

    var body: some View {
        ZStack {
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

            // Animation
            ZStack {
                Color.red
                Image("Appsterdam_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .scaleEffect(animate ? 1000 : 1)
                    .animation(.easeIn, value: animate)
            }
            .zIndex(100)
            .edgesIgnoringSafeArea(.all)
            .opacity(showSplash ? 1 : 0)
            .animation(.easeOut, value: animate)
            .navigationBarHidden(showSplash)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if showSplash {
                        animate = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showSplash = false
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
