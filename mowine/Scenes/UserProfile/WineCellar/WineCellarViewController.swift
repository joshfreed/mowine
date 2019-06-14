//
//  WineCellarViewController.swift
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

protocol WineCellarDisplayLogic: class {
    func displayWineTypes(viewModel: WineCellar.GetWineTypes.ViewModel)
    func displaySelectedType(viewModel: WineCellar.SelectType.ViewModel)
}

class WineCellarViewController: UIViewController, WineCellarDisplayLogic {
    var interactor: WineCellarBusinessLogic?
    var router: (NSObjectProtocol & WineCellarRoutingLogic & WineCellarDataPassing)?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyCellarLabel: UILabel!
    
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
        let interactor = WineCellarInteractor()
        let presenter = WineCellarPresenter()
        let router = WineCellarRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = WineCellarWorker(
            wineTypeRepository: JFContainer.shared.wineTypeRepository,
            userRepository: JFContainer.shared.userRepository,
            wineRepository: JFContainer.shared.wineRepository
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
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
    }

    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!

    func doSomething() {
        let request = WineCellar.GetWineTypes.Request()
        interactor?.getWineTypes(request: request)
    }

    func displayWineTypes(viewModel: WineCellar.GetWineTypes.ViewModel) {
        let types = viewModel.types
        
        emptyCellarLabel.isHidden = !types.isEmpty
        
        var lastView: UIView?
        types.forEach {
            let button = ButtonPrimaryGradient()
            button.awakeFromNib()
            button.titleLabel?.font = UIFont.systemFont(ofSize: 37, weight: UIFont.Weight.light)
            button.setTitle($0, for: .normal)
            button.addTarget(self, action: #selector(tappedTypeButton), for: .touchUpInside)
            contentView.addSubview(button)
            button.autoSetDimension(.height, toSize: 80)
            button.autoPinEdge(.leading, to: .leading, of: contentView)
            button.autoPinEdge(.trailing, to: .trailing, of: contentView)
            
            if let lastView = lastView {
                button.autoPinEdge(.top, to: .bottom, of: lastView, withOffset: 4)
            } else {
                button.autoPinEdge(toSuperviewEdge: .top)
            }
            
            button.layoutIfNeeded()
            button.applyGradient()
            
            lastView = button
        }
        
        if let lastView = lastView {
            lastView.autoPinEdge(toSuperviewEdge: .bottom)
        }
    }
    
    // MARK: Select type
    
    @objc func tappedTypeButton(button: ButtonPrimary) {
        guard let type = button.title(for: .normal) else {
            return
        }
        
        selectType(type)
    }
    
    func selectType(_ type: String) {
        let request = WineCellar.SelectType.Request(type: type)
        interactor?.selectType(request: request)
    }
    
    func displaySelectedType(viewModel: WineCellar.SelectType.ViewModel) {
        performSegue(withIdentifier: "WineCellarList", sender: nil)
    }
}
