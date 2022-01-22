//
//  AboutViewController.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 21/01/2022.
//

import UIKit
import SwiftUI

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Custom function, to add swifUI view as subview.
        self.addSubview(
            AboutView(),
            to: self.view
        )
    }
}
