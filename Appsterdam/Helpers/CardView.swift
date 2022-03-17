//
//  CardView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 17/03/2022.
//  Copyright © 2022 Stichting Appsterdam. All rights reserved.
//

import SwiftUI
import Aurora

struct CardView<Content: View>: View {
    // To dismiss this screen using the button.
    @Environment(\.presentationMode) var presentationMode

    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var CloseButton: some View {
        Image(systemName: "xmark")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .padding(.all, 5)
            .background(Color.black.opacity(0.6))
            .clipShape(Circle())
            .accessibility(label:Text("Close"))
            .accessibility(hint:Text("Tap to close the screen"))
            .accessibility(addTraits: .isButton)
            .accessibility(removeTraits: .isImage)
    }

    var body: some View {
        VStack {
            HStack() {
                Text(title)
                    .font(.title)
                    .lineLimit(1)
                    .padding(.leading, 10)

                // To make it on the right
                Spacer()

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: { self.CloseButton })
            }.padding(5)

            // Custom Content
            self.content
                .padding(.top, 5)

            // Move everything up
            Spacer()
        }
    }
}

struct CardViewPreviews: PreviewProvider {
    static var previews: some View {
        CardView(title: "Title") {
            Text("Hello")
        }
    }
}
