//
//  MyAccountRouter.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol MyAccountRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeToMainMenu()
}

protocol MyAccountDataPassing {
    var dataStore: MyAccountDataStore? { get }
}

class MyAccountRouter: NSObject, MyAccountRoutingLogic, MyAccountDataPassing {
    weak var viewController: MyAccountViewController?
    var dataStore: MyAccountDataStore?

    // MARK: Routing
    func routeToMainMenu() {
        viewController?.navigationController?.popToRootViewController(animated: true)
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

    //func navigateToSomewhere(source: MyAccountViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    //func passDataToSomewhere(source: MyAccountDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
