//
//  TopWinesViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/14/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TopWinesDisplayLogic: class {
    func displayTopWines(viewModel: TopWines.FetchTopWines.ViewModel)
}

class TopWinesViewController: UIViewController, TopWinesDisplayLogic {
    var interactor: TopWinesBusinessLogic?
    var router: (NSObjectProtocol & TopWinesRoutingLogic & TopWinesDataPassing)?
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
        let interactor = TopWinesInteractor()
        let presenter = TopWinesPresenter()
        let router = TopWinesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = TopWinesWorker(wineRepository: Container.shared.wineRepository)
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
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopWines()
    }

    // MARK: Fetch top wines

    //@IBOutlet weak var nameTextField: UITextField!

    func fetchTopWines() {
        let request = TopWines.FetchTopWines.Request()
        interactor?.fetchTopWines(request: request)
    }

    func displayTopWines(viewModel: TopWines.FetchTopWines.ViewModel) {
        wineListViewController.wines = viewModel.wines
    }
}
