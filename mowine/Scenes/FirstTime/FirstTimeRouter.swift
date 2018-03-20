//
//  FirstTimeRouter.swift
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

@objc protocol FirstTimeRoutingLogic {
    func routeToSignIn(segue: UIStoryboardSegue)
    func routeToSignUp(segue: UIStoryboardSegue)
}

protocol FirstTimeDataPassing {
    var dataStore: FirstTimeDataStore? { get }
}

class FirstTimeRouter: NSObject, FirstTimeRoutingLogic, FirstTimeDataPassing {
    weak var viewController: FirstTimeViewController?
    var dataStore: FirstTimeDataStore?

    // MARK: Routing

    func routeToSignIn(segue: UIStoryboardSegue) {
        
    }
    
    func routeToSignUp(segue: UIStoryboardSegue) {
        
    }
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

    //func navigateToSomewhere(source: FirstTimeViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    //func passDataToSomewhere(source: FirstTimeDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
