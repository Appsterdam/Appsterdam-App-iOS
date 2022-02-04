//
//  SafariView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 24/01/2022.
//

#if canImport(swiftUI) && canImport(SafariServices)
import SwiftUI
import SafariServices
import UIKit
import Aurora

/// Make a Safari View for SwiftUI
struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController

    @Binding var urlString: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        guard let url = URL(string: urlString.latinized) else {
            fatalError("Invalid urlString: \(urlString)")
        }

        // TODO: Remove this debug line
        Aurora.shared.log("SFSafari: \(url.relativeString)")

        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = UIColor(Color.accentColor)
        safariViewController.dismissButtonStyle = .close

        return safariViewController
    }

    func updateUIViewController(_ safariViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        return
    }
}
#endif
