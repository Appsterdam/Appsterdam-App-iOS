//
//  onRotate.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 28/01/2022.
//

import SwiftUI

/// A view wrapper for
extension View {
    /// Perform an action only if the device is landscape mode
    ///
    /// Only perform a view modifier if the device is in landscape mode.
    /// Use this view modifier after your element. e.g.
    ///
    ///     Text("I will be hidden, if we are in landscape mode")
    ///       .onLandscape {
    ///         // Hide if we are in landscape mode
    ///         $0.hidden()
    ///       }
    ///
    /// - Returns: ViewModifier
    @ViewBuilder public func onLandscape<Transform: View>(transform: (Self) -> Transform) -> some View {
        if UIScreen.main.traitCollection.verticalSizeClass == .compact {
            transform(self)
        }
        else {
            self
        }
    }

    /// Perform an action only if the device is portrait mode
    ///
    /// Only perform a view modifier if the device is in portrait mode.
    /// Use this view modifier after your element. e.g.
    ///
    ///     Text("I will be hidden, if we are in portrait mode")
    ///       .onPortrait {
    ///         // Hide if we are in portrait mode
    ///         $0.hidden()
    ///       }
    ///
    /// - Returns: ViewModifier
    @ViewBuilder public func onPortrait<Transform: View>(transform: (Self) -> Transform) -> some View {
        if UIScreen.main.traitCollection.verticalSizeClass == .regular {
            transform(self)
        }
        else {
            self
        }
    }
}
