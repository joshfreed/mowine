//
//  SelectVarietyViewController.swift
//  mowine
//
//  Created by Josh Freed on 7/4/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectVarietyDisplayLogic: class {
    func displayVarieties(viewModel: SelectVariety.FetchVarieties.ViewModel)
    func displaySelectedVariety(viewModel: SelectVariety.SelectVariety.ViewModel)
}

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
