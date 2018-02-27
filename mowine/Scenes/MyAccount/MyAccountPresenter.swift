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

protocol MyAccountPresentationLogic {
    func presentSomething(response: MyAccount.Something.Response)
}

class MyAccountPresenter: MyAccountPresentationLogic {
    weak var viewController: MyAccountDisplayLogic?

    // MARK: Do something

    func presentSomething(response: MyAccount.Something.Response) {
        let viewModel = MyAccount.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
