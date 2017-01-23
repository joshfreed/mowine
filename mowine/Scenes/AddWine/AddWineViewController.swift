//
//  AddWineViewController.swift
//  mowine
//
//  Created by Josh Freed on 1/7/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Eureka

protocol AddWineViewControllerInput {
    func displayForm(viewModel: AddWine.FetchForm.ViewModel)
}

protocol AddWineViewControllerOutput {
    func fetchForm(request: AddWine.FetchForm.Request)
    func addWine(request: AddWine.SaveWine.Request)
}

class AddWineViewController: FormViewController, AddWineViewControllerInput {
    var output: AddWineViewControllerOutput!
    var router: AddWineRouter!

    // MARK: - Object lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        AddWineConfigurator.sharedInstance.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchFormOnLoad()
    }

    // MARK: - Event handling
    
    func fetchFormOnLoad() {
        let request = AddWine.FetchForm.Request()
        output.fetchForm(request: request)
    }
    
    @IBAction func saveWineAction(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Display logic

    func displayForm(viewModel: AddWine.FetchForm.ViewModel) {
        let varietyRow = PushRow<String>("variety") {
            $0.title = "Variety"
            $0.options = []
        }
        
        form = Section()
            <<< TextRow("name") {
                $0.title = "Name"
                $0.placeholder = "Fancy Wine Name"
            }
            +++ Section()
            <<< PushRow<AddWine.FetchForm.ViewModel.WineType>("type") {
                $0.title = "Type"
                $0.options = viewModel.types
                }.onChange { row in
                    if let value = row.value {
                        varietyRow.options = value.varieties
                    } else {
                        varietyRow.options = []
                    }
                    
                    varietyRow.value = nil
                    varietyRow.updateCell()
                }
            <<< varietyRow
            <<< TextRow("location") {
                $0.title = "Location"
                $0.placeholder = "Where did I find this wine?"
            }
            <<< DecimalRow("price") {
                $0.title = "Price"
                $0.placeholder = "How much was this wine?"
            }
            +++ Section("Pairs well with")
            +++ Section("Notes")
            <<< TextAreaRow()
    }
}
