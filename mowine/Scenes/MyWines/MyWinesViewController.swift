//
//  MyWinesViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/15/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MyWinesDisplayLogic: class {
    func displayMyWines(viewModel: MyWines.FetchMyWines.ViewModel)
    func displayUpdatedWine(viewModel: WineListViewModel)
}

class MyWinesViewController: UIViewController, MyWinesDisplayLogic {
    var interactor: MyWinesBusinessLogic?
    var router: (NSObjectProtocol & MyWinesRoutingLogic & MyWinesDataPassing)?
    weak var wineListViewController: WineListViewController?
    
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
        let interactor = MyWinesInteractor()
        let presenter = MyWinesPresenter()
        let router = MyWinesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = MyWinesWorker(
            wineRepository: Container.shared.wineRepository,
            session: Container.shared.session
        )
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
        
        if segue.identifier == "WineList" {
            let vc = segue.destination as! WineListViewController
            wineListViewController = vc
            wineListViewController?.delegate = self
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMyWines()
    }

    // MARK: Fetch my wines
    
    func fetchMyWines() {
        let request = MyWines.FetchMyWines.Request()
        interactor?.fetchMyWines(request: request)
    }
    
    func displayMyWines(viewModel: MyWines.FetchMyWines.ViewModel) {
        wineListViewController?.wines = viewModel.wines
    }
    
    // MARK: Display updated wine
    
    func displayUpdatedWine(viewModel: WineListViewModel) {
        wineListViewController?.update(wine: viewModel)
    }
    
    // MARK: Select wine
    
    func selectWine(atIndex index: Int) {
        interactor?.selectWine(atIndex: index)
        performSegue(withIdentifier: "EditWine", sender: nil)
    }
}

extension MyWinesViewController: WineListViewControllerDelegate {
    func didSelectWine(_ wine: WineListViewModel, at indexPath: IndexPath) {
        selectWine(atIndex: indexPath.row)
    }
}
