//
//  SelectTypeViewController.swift
//  mowine
//
//  Created by Josh Freed on 6/26/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectTypeDisplayLogic: class {
    func displaySelectedType(viewModel: SelectType.SelectType.ViewModel)
}

class SelectTypeViewController: UIViewController, SelectTypeDisplayLogic {
    var interactor: SelectTypeBusinessLogic?
    var router: (NSObjectProtocol & SelectTypeRoutingLogic & SelectTypeDataPassing)?
    
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
        let interactor = SelectTypeInteractor()
        let presenter = SelectTypePresenter()
        let router = SelectTypeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = SelectTypeWorker(wineTypeRepository: Container.shared.wineTypeRepository)
        
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
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet var wineTypeButtons: [ButtonPrimary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerImage.fixTintIssue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideNavigationBar()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Select wine type
    
    @IBAction func selectWineType(_ sender: ButtonPrimary) {
        guard let type = sender.title(for: .normal) else {
            return
        }
        
        let request = SelectType.SelectType.Request(type: type)
        interactor?.selectType(request: request)
    }

    func displaySelectedType(viewModel: SelectType.SelectType.ViewModel) {
        performSegue(withIdentifier: "SelectVariety", sender: nil)
    }
}
