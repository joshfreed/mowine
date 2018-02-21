//
//  MyWinesConfigurator.swift
//  mowine
//
//  Created by Josh Freed on 1/7/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension MyWinesViewController: MyWinesPresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension MyWinesInteractor: MyWinesViewControllerOutput {
}

extension MyWinesPresenter: MyWinesInteractorOutput {
}

class MyWinesConfigurator {
    // MARK: - Object lifecycle

    static let sharedInstance = MyWinesConfigurator()

    private init() {
    }

    // MARK: - Configuration

    func configure(viewController: MyWinesViewController) {
        let router = MyWinesRouter()
        router.viewController = viewController

        let presenter = MyWinesPresenter()
        presenter.output = viewController

        let interactor = MyWinesInteractor()
        interactor.output = presenter
        interactor.worker = MyWinesWorker(wineRepository: Container.shared.wineRepository)

        viewController.output = interactor
        viewController.router = router
    }
}
