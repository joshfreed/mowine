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
    @IBOutlet weak var buttonContainer: UIView!
    
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
        
        var lastView: UIView?
        varieties.forEach {
            let button = ButtonPrimaryGradient()
            button.awakeFromNib()
            button.setTitle($0, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.light)
            button.addTarget(self, action: #selector(didTapVarietyButton), for: .touchUpInside)
            buttonContainer.addSubview(button)
            button.autoSetDimension(.height, toSize: 80)
            button.autoPinEdge(.leading, to: .leading, of: buttonContainer)
            button.autoPinEdge(.trailing, to: .trailing, of: buttonContainer)
            
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
    
    // MARK: Select Variety
    
    @objc func didTapVarietyButton(button: ButtonPrimary) {
        guard let variety = button.title(for: .normal) else {
            return
        }
        
        selectVariety(variety)
    }
    
    func selectVariety(_ variety: String) {
        let request = SelectVariety.SelectVariety.Request(variety: variety)
        interactor?.selectVariety(request: request)
    }
    
    func displaySelectedVariety(viewModel: SelectVariety.SelectVariety.ViewModel) {
        performSegue(withIdentifier: "SnapPhoto", sender: nil)
    }
}

/*
class SelectVarietyViewController: UICollectionViewController, SelectVarietyDisplayLogic, UICollectionViewDelegateFlowLayout {
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
        collectionView?.delegate = self
        fetchVarieties()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return varieties.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VarietyCollectionViewCell", for: indexPath) as! VarietyCollectionViewCell
        cell.configure(variety: varieties[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectVariety(varieties[indexPath.row])
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Does not use a flow layout")
        }
        
        let collectionViewWidth = collectionView.frame.size.width
            - flow.sectionInset.left
            - flow.sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        
        let itemWidth = collectionViewWidth
        
        return CGSize(width: itemWidth, height: 70)
    }
    
    // MARK: Fetch Varieties
    
    private(set) var varieties: [String] = []
    
    func fetchVarieties() {
        let request = SelectVariety.FetchVarieties.Request()
        interactor?.fetchVarieties(request: request)
    }
    
    func displayVarieties(viewModel: SelectVariety.FetchVarieties.ViewModel) {
        varieties = viewModel.varieties
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
*/
