//
//  EditWinePresenter.swift
//  mowine
//
//  Created by Josh Freed on 2/18/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol EditWinePresenterInput {
    func presentWine(response: EditWine.FetchWine.Response)
    func navigateToMyWines()
    func presentError(_ error: Error)
}

protocol EditWinePresenterOutput: class {
    func displayWine(viewModel: EditWine.FetchWine.ViewModel)
    func navigateToMyWines()
    func presentError(_ error: Error)
}

class EditWinePresenter: EditWinePresenterInput {
    weak var output: EditWinePresenterOutput!

    // MARK: - Presentation logic

    func presentWine(response: EditWine.FetchWine.Response) {
        let  wineTypes = buildWineTypeViewModels(fromModel: response.wineTypes)

        var wineViewModel = WineViewModel(name: response.wine.name, rating: response.wine.rating)
        wineViewModel.location = response.wine.location
        wineViewModel.notes = response.wine.notes
        
        if let price = response.wine.price {
            wineViewModel.price = Double(price)
        }
        
        if let data = response.wine.photo {
            wineViewModel.image = UIImage(data: data as Data)
        }
        
        let varietyName = response.wine.variety.name
        if let selectedTypeViewModel = wineTypes.filter({ $0.varieties.contains(varietyName) }).first {
            wineViewModel.variety = varietyName
            wineViewModel.type = selectedTypeViewModel
        }

        wineViewModel.pairings = response.wine.pairings
        
        let viewModel = EditWine.FetchWine.ViewModel(
            wineViewModel: wineViewModel,
            wineTypes: wineTypes
        )
        
        output.displayWine(viewModel: viewModel)
    }
    
    private func buildWineTypeViewModels(fromModel wineTypes: [WineType]) -> [WineTypeViewModel] {
        var types: [WineTypeViewModel] = []
        
        for type in wineTypes {
            let varietyNames: [String] = type.varieties.map({ $0.name })
            types.append(WineTypeViewModel(name: type.name, varieties: varietyNames))
        }
        
        return types
    }
    
    func navigateToMyWines() {
        output.navigateToMyWines()
    }
    
    func presentError(_ error: Error) {
        output.presentError(error)
    }
}
