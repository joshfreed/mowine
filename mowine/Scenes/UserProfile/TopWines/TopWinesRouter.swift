//
//  TopWinesRouter.swift
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

@objc protocol TopWinesRoutingLogic {
    func routeToWineDetails()
}

protocol TopWinesDataPassing {
    var dataStore: TopWinesDataStore? { get }
}

class TopWinesRouter: NSObject, TopWinesRoutingLogic, TopWinesDataPassing {
    weak var viewController: TopWinesViewController?
    var dataStore: TopWinesDataStore?

    // MARK: Routing

    func routeToWineDetails() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "WineDetailsViewController") as! WineDetailsViewController
        var destinationDS = destinationVC.interactor as! WineDetailsDataStore
        passDataToWineDetails(source: dataStore!, destination: &destinationDS)
        navigateToWineDetails(source: viewController!, destination: destinationVC)
    }

    // MARK: Navigation

    func navigateToWineDetails(source: TopWinesViewController, destination: WineDetailsViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }

    // MARK: Passing data

    func passDataToWineDetails(source: TopWinesDataStore, destination: inout WineDetailsDataStore) {
        destination.wine = source.selectedWine
    }
}