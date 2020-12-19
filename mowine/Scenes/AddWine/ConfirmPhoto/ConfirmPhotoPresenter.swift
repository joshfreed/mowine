//
//  ConfirmPhotoPresenter.swift
//  mowine
//
//  Created by Josh Freed on 8/11/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ConfirmPhotoPresentationLogic {
    func presentPhotoPreview(response: ConfirmPhoto.GetPhotoPreview.Response)
}

class ConfirmPhotoPresenter: ConfirmPhotoPresentationLogic {
    weak var viewController: ConfirmPhotoDisplayLogic?

    // MARK: Get photo preview

    func presentPhotoPreview(response: ConfirmPhoto.GetPhotoPreview.Response) {
        let viewModel = ConfirmPhoto.GetPhotoPreview.ViewModel(photo: response.photo)
        viewController?.displayPhotoPreview(viewModel: viewModel)
    }
}