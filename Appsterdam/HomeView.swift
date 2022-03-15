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
    
    @State var animate = false
    @State var showSplash = true
    
    var body: some View {
        NavigationView {
            
            ZStack {
                ZStack {
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
                                        UIApplication.shared.openAppSettings()
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
                    }
                    // Safari
                    .sheet(isPresented: $showSafari,
                           content: {
                        SafariView(url: $urlString)
                    })
                }
                
                // Animation
                ZStack {
                    Color.red
                    Image("Appsterdam_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .scaleEffect(animate ? 1000 : 1)
                        .animation(Animation.easeIn(duration: 1))
                }
                .zIndex(100)
                .edgesIgnoringSafeArea(.all)
                .opacity(showSplash ? 1 : 0)
                .animation(Animation.easeOut(duration: 1.5))
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
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
