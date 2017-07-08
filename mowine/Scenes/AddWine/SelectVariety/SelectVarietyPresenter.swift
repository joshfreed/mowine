//
//  SelectVarietyPresenter.swift
//  mowine
//
//  Created by Josh Freed on 7/4/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectVarietyPresentationLogic {
    func presentVarieties(response: SelectVariety.FetchVarieties.Response)
    func presentSelectedVariety(response: SelectVariety.SelectVariety.Response)
}

class SelectVarietyPresenter: SelectVarietyPresentationLogic {
    weak var viewController: SelectVarietyDisplayLogic?

    // MARK: Present varieties

    func presentVarieties(response: SelectVariety.FetchVarieties.Response) {
        let varieties = response.varieties
            .filter({ $0.name != nil })
            .map({ $0.name! })
            .sorted()
        
        let viewModel = SelectVariety.FetchVarieties.ViewModel(varieties: varieties)
        viewController?.displayVarieties(viewModel: viewModel)
    }

    // MARK: Present selected variety
    
    func presentSelectedVariety(response: SelectVariety.SelectVariety.Response) {
        let viewModel = SelectVariety.SelectVariety.ViewModel()
        viewController?.displaySelectedVariety(viewModel: viewModel)
    }
}
