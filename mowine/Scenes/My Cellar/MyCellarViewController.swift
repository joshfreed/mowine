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
    private var selectedWineId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        viewModel = MyCellarViewModel(wineTypeRepository: JFContainer.shared.wineTypeRepository)
        viewModel.onEditWine = { [weak self] wineId in
            self?.selectedWineId = wineId
            self?.performSegue(withIdentifier: "editWine", sender: nil)
        }
        let rootView = MyCellarView(viewModel: viewModel)
        return UIHostingController(coder: coder, rootView: rootView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editWine" {
            let nc = segue.destination as! UINavigationController
            let vc = nc.topViewController as! EditWineViewController
            vc.wineId = selectedWineId
        }
    }

    @IBAction func unwindToMyCellar(_ unwindSegue: UIStoryboardSegue) {

    }
}
