//
//  RateWinePresenter.swift
//  mowine
//
//  Created by Josh Freed on 9/20/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RateWinePresentationLogic {
    func presentWine(response: RateWine.GetWine.Response)
}

class RateWinePresenter: RateWinePresentationLogic {
    weak var viewController: RateWineDisplayLogic?

    // MARK: Get wine

    func presentWine(response: RateWine.GetWine.Response) {
        let viewModel = RateWine.GetWine.ViewModel(photo: response.photo, name: response.name)
        viewController?.displayWine(viewModel: viewModel)
    }
}
