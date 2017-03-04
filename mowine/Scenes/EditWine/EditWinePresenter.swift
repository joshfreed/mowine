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

        var wineViewModel = WineViewModel(name: response.wine.name ?? "", rating: response.wine.rating)
        
        if let data = response.wine.image {
            wineViewModel.image = UIImage(data: data as Data)
        }
        
        if let varietyName = response.wine.variety?.name,
            let selectedTypeViewModel = wineTypes.filter({ $0.varieties.contains(varietyName) }).first
        {
            wineViewModel.variety = varietyName
            wineViewModel.type = selectedTypeViewModel
        }
        
        let viewModel = EditWine.FetchWine.ViewModel(
            wineViewModel: wineViewModel,
            wineTypes: wineTypes
        )
        
        output.displayWine(viewModel: viewModel)
    }
    
    private func buildWineTypeViewModels(fromModel wineTypes: [Type]) -> [WineTypeViewModel] {
        var types: [WineTypeViewModel] = []
        
        for type in wineTypes {
            guard let name = type.name,
                let nsset = type.varieties,
                let varieties = nsset.allObjects as? [Variety]
                else {
                    continue
            }
            
            let varietyNames: [String] = varieties
                .filter({ $0.name != nil })
                .map({ $0.name! })
            
            types.append(WineTypeViewModel(name: name, varieties: varietyNames))
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
