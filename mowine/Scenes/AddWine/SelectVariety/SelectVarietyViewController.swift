//
//  SelectVarietyViewController.swift
//  mowine
//
//  Created by Josh Freed on 9/27/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

protocol SelectVarietyDisplayLogic: class {
    func displayVarieties(viewModel: SelectVariety.FetchVarieties.ViewModel)
    func displaySelectedVariety(viewModel: SelectVariety.SelectVariety.ViewModel)
}

class SelectVarietyViewController: UIViewController, SelectVarietyDisplayLogic {
    var interactor: SelectVarietyBusinessLogic?
    var router: (NSObjectProtocol & SelectVarietyRoutingLogic & SelectVarietyDataPassing)?
    
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
        let interactor = SelectVarietyInteractor()
        let presenter = SelectVarietyPresenter()
        let router = SelectVarietyRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
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
        
        fetchVarieties()
    }

    // MARK: Fetch Varieties
    
    private(set) var varieties: [String] = []
    
    func fetchVarieties() {
        let request = SelectVariety.FetchVarieties.Request()
        interactor?.fetchVarieties(request: request)
    }
    
    func displayVarieties(viewModel: SelectVariety.FetchVarieties.ViewModel) {
        varieties = viewModel.varieties
        varieties.forEach {
            let button = ButtonPrimary()
            button.setTitle($0, for: .normal)
        }
    }
    
    // MARK: Select Variety
    
    func selectVariety(_ variety: String) {
        let request = SelectVariety.SelectVariety.Request(variety: variety)
        interactor?.selectVariety(request: request)
    }
    
    func displaySelectedVariety(viewModel: SelectVariety.SelectVariety.ViewModel) {
        performSegue(withIdentifier: "SnapPhoto", sender: nil)
    }
}
