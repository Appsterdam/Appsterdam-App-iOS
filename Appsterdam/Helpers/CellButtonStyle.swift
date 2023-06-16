//
//  CellButtonStyle.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 16/06/2023.
//  Copyright © 2023 Stichting Appsterdam. All rights reserved.
//

import Foundation
import SwiftUI

/// Hack to make buttons always clickable on the whole surface area not only on text / images.
///
/// Usage:
/// ```swift
/// Button {
///  /* Action*/
/// } label: {
///  /* Label*/
/// }
/// .buttonStyle(CellButtonStyle())
/// ```
struct CellButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.init(red: 0, green: 0, blue: 0, opacity: 0.0001))
    }
}
