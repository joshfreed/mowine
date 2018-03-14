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
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol TopWinesDataPassing {
    var dataStore: TopWinesDataStore? { get }
}

class TopWinesRouter: NSObject, TopWinesRoutingLogic, TopWinesDataPassing {
    weak var viewController: TopWinesViewController?
    var dataStore: TopWinesDataStore?

    // MARK: Routing

    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}

    // MARK: Navigation

    //func navigateToSomewhere(source: TopWinesViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    //func passDataToSomewhere(source: TopWinesDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
