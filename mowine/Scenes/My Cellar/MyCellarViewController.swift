//
//  MyCellarViewController.swift
//  mowine
//
//  Created by Josh Freed on 10/4/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit
import SwiftUI

class MyCellarViewController: UIViewController {
    private var viewModel: MyCellarViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        viewModel = MyCellarViewModel()
        return UIHostingController(coder: coder, rootView: MyCellarView(viewModel: viewModel))
    }
}
