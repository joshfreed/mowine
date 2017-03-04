//
//  AddWinePresenter.swift
//  mowine
//
//  Created by Josh Freed on 1/7/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol AddWinePresenterInput {
    func presentForm(response: AddWine.FetchForm.Response)
    func presentWine(response: AddWine.SaveWine.Response)
    func presentError(_ error: Error)
}

protocol AddWinePresenterOutput: class {
    func displayForm(viewModel: AddWine.FetchForm.ViewModel)
    func displayNewWine()
    func displayError(_ error: Error)
}

class AddWinePresenter: AddWinePresenterInput {
    weak var output: AddWinePresenterOutput!

    // MARK: - Presentation logic

    func presentForm(response: AddWine.FetchForm.Response) {
        var types: [WineTypeViewModel] = []
        
        for type in response.wineTypes {
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
        
        let viewModel = AddWine.FetchForm.ViewModel(types: types)
        
        output.displayForm(viewModel: viewModel)
    }
    
    func presentWine(response: AddWine.SaveWine.Response) {
        output.displayNewWine()
    }
    
    func presentError(_ error: Error) {
        output.displayError(error)
    }
}
