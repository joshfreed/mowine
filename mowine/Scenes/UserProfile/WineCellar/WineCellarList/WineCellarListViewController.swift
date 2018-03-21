//
//  WineCellarListViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/20/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol WineCellarListDisplayLogic: class {
    func displayCellarName(viewModel: WineCellarList.GetCellarName.ViewModel)
    func displayWines(viewModel: WineCellarList.FetchWines.ViewModel)
}

class WineCellarListViewController: UIViewController, WineCellarListDisplayLogic {
    var interactor: WineCellarListBusinessLogic?
    var router: (NSObjectProtocol & WineCellarListRoutingLogic & WineCellarListDataPassing)?
    weak var wineListViewController: WineListViewController!

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = WineCellarListInteractor()
        let presenter = WineCellarListPresenter()
        let router = WineCellarListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = WineCellarListWorker(wineRepository: Container.shared.wineRepository)
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWines()
    }
    
    func displayCellarName(viewModel: WineCellarList.GetCellarName.ViewModel) {
        navigationItem.title = viewModel.cellarName
    }

    // MARK: Fetch wines

    //@IBOutlet weak var nameTextField: UITextField!

    func fetchWines() {
        let request = WineCellarList.FetchWines.Request()
        interactor?.fetchWines(request: request)
    }

    func displayWines(viewModel: WineCellarList.FetchWines.ViewModel) {
        wineListViewController.wines = viewModel.wines
    }
    
    // MARK: Select wine
    
    func selectWine(wineId: String) {
        let request = WineCellarList.SelectWine.Request(wineId: wineId)
        interactor?.selectWine(request: request)
        
        router?.routeToWineDetails()
    }
}

extension WineCellarListViewController: WineListViewControllerDelegate {
    func didSelectWine(_ wine: WineListViewModel, at indexPath: IndexPath) {
        selectWine(wineId: wine.id)
    }
}
