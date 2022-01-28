//
//  onRotate.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 28/01/2022.
//

import SwiftUI

// A View wrapper to make the modifier easier to use
extension View {
    @ViewBuilder
    func onLandscape<Transform: View>(transform: (Self) -> Transform) -> some View {
        if UIScreen.main.traitCollection.verticalSizeClass == .compact {
            transform(self)
        }
        else {
            self
        }
    }

    @ViewBuilder
    func onPortrait<Transform: View>(transform: (Self) -> Transform) -> some View {
        if UIScreen.main.traitCollection.verticalSizeClass == .regular {
            transform(self)
        }
        else {
            self
        }
    }
}
