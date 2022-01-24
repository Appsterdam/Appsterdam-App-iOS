//
//  SafariView.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 24/01/2022.
//

import SwiftUI
import SafariServices
import UIKit

/// Make a Safari View for SwiftUI
struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController

    @Binding var urlString: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid urlString: \(urlString)")
        }

        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = UIColor(Color.accentColor)
        safariViewController.dismissButtonStyle = .close

        return safariViewController
    }

    func updateUIViewController(_ safariViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        return
    }
}
