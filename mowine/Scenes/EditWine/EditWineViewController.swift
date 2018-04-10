//
//  EditWineViewController.swift
//  mowine
//
//  Created by Josh Freed on 2/18/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Eureka

protocol EditWineViewControllerInput {
    func displayWine(viewModel: EditWine.FetchWine.ViewModel)
    func navigateToMyWines()
    func presentError(_ error: Error)
}

protocol EditWineViewControllerOutput {
    var wine: Wine! { get set }
    func fetchWine(request: EditWine.FetchWine.Request)
    func saveWine(request: EditWine.SaveWine.Request)
}

class EditWineViewController: FormViewController, EditWineViewControllerInput {
    var output: EditWineViewControllerOutput!
    var router: EditWineRouter!
    let wineForm = WineForm()

    // MARK: - Object lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        EditWineConfigurator.sharedInstance.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildForm()
        fetchWineOnLoad()
    }
    
    func buildForm() {
        form = wineForm.makeWineForm()
    }
    
    // MARK: - Event handling

    func fetchWineOnLoad() {
        output.fetchWine(request: EditWine.FetchWine.Request())
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        router.navigateToMyWines()
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let valuesDictionary = form.values()
        
        guard let name = valuesDictionary["name"] as? String else {
            return
        }
        guard let rating = valuesDictionary["rating"] as? Double else {
            return
        }
        guard let type = valuesDictionary["type"] as? WineTypeViewModel else {
            return
        }
        
        let variety = valuesDictionary["variety"] as? String
        let location = valuesDictionary["location"] as? String
        let price = valuesDictionary["price"] as? String
        let notes = valuesDictionary["notes"] as? String
        
        var request = EditWine.SaveWine.Request(name: name, rating: rating, type: type.name)
        request.variety = variety
        request.location = location
        request.price = price
        request.notes = notes
        
        request.image = valuesDictionary["photo"] as? UIImage
        
        for (name, value) in valuesDictionary {
            if name.hasPrefix("pairing_"), let food = value as? String {
                request.pairings.append(food)
            }
        }
        
        output.saveWine(request: request)
    }

    // MARK: - Display logic

    func displayWine(viewModel: EditWine.FetchWine.ViewModel) {
        wineForm.nameRow.value = viewModel.wineViewModel.name
        wineForm.ratingRow.value = viewModel.wineViewModel.rating
        wineForm.photoRow.value = viewModel.wineViewModel.image
        wineForm.typeRow.options = viewModel.wineTypes
        wineForm.typeRow.value = viewModel.wineViewModel.type
        wineForm.varietyRow.value = viewModel.wineViewModel.variety
        wineForm.locationRow.value = viewModel.wineViewModel.location
        wineForm.priceRow.value = viewModel.wineViewModel.price
        wineForm.noteRow.value = viewModel.wineViewModel.notes

        wineForm.varietyRow.hidden = Condition.function(["type"], { form in
            if let value = self.wineForm.typeRow.value {
                return value.varieties.count == 0
            } else {
                return true
            }
        })
        wineForm.varietyRow.evaluateHidden()
        
        for (index, name) in viewModel.wineViewModel.pairings.enumerated() {
            let newRow = NameRow("pairing_\(index + 1)") {
                $0.placeholder = "e.g. Sushi, Cheese, etc"
                $0.value = name
            }
            wineForm.pairingsSection.insert(newRow, at: index)
        }
    }
    
    func navigateToMyWines() {
        router.navigateToMyWines()
    }
    
    func presentError(_ error: Error) {
//        showAlert(error: error)
    }
}
