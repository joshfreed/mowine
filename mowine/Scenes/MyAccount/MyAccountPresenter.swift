//
//  MyAccountPresenter.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftyBeaver

protocol MyAccountPresentationLogic {
    func presentUser(response: MyAccount.GetUser.Response)
    func presentErrorGettingUser()
    func presentSignedOut(response: MyAccount.SignOut.Response)
    func presentError(_ error: Error)
    func presentProfilePicture(data: Data?)
}

class MyAccountPresenter: MyAccountPresentationLogic {
    weak var viewController: MyAccountDisplayLogic?

    func presentError(_ error: Error) {
        SwiftyBeaver.error("\(error)")
    }

    // MARK: Get User

    func presentUser(response: MyAccount.GetUser.Response) {
        let viewModel = MyAccount.GetUser.ViewModel(
            fullName: response.user.fullName,
            emailAddress: response.user.emailAddress,
            profilePicture: response.user.profilePicture ?? #imageLiteral(resourceName: "No Profile Picture")
        )
        viewController?.displayUser(viewModel: viewModel)
    }
    
    func presentErrorGettingUser() {
        viewController?.displayErrorGettingUser()
    }
    
    // MARK: Sign out
    
    func presentSignedOut(response: MyAccount.SignOut.Response) {
        let viewModel = MyAccount.SignOut.ViewModel()
        viewController?.displaySignedOut(viewModel: viewModel)
    }

    // MARK: Get profile picture

    func presentProfilePicture(data: Data?) {
        var image: UIImage?
        if let data = data {
            image = UIImage(data: data)
        }
        viewController?.displayProfilePicture(image: image)
    }
}
