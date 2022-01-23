//
//  HomeView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 22/01/2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image("Appsterdam_logo", bundle: nil, label: Text("Appsterdam Logo"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()

                Text(" Welcome 😄 ")
                    .font(.largeTitle)
                    .padding()

                Text("This is an SwiftUI View.")
                    .padding()

                Text("This is suprt long text, written by me, without any meaning, or real purpose, the only purpose is to have a really long string, what fills the content, and make this view scroll, it can, or may, repeat itself at some point, but when, is the question, this string doesnt seem that long, yet, so it may become a little bit longer, This is suprt long text, written by me, without any meaning, or real purpose, the only purpose is to have a really long string, what fills the content, and make this view scroll, it can, or may, repeat itself at some point, but when, is the question, this string doesnt seem that long, yet, so it may become a little bit longer, This is suprt long text, written by me, without any meaning, or real purpose, the only purpose is to have a really long string, what fills the content, and make this view scroll, it can, or may, repeat itself at some point, but when, is the question, this string doesnt seem that long, yet, so it may become a little bit longer, This is suprt long text, written by me, without any meaning, or real purpose, the only purpose is to have a really long string, what fills the content, and make this view scroll, it can, or may, repeat itself at some point, but when, is the question, this string doesnt seem that long, yet, so it may become a little bit longer, This is the end.")

                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
