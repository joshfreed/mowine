//
//  ConfirmPhotoRouter.swift
//  mowine
//
//  Created by Josh Freed on 8/11/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ConfirmPhotoRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ConfirmPhotoDataPassing {
    var dataStore: ConfirmPhotoDataStore? { get }
}

class ConfirmPhotoRouter: NSObject, ConfirmPhotoRoutingLogic, ConfirmPhotoDataPassing {
    weak var viewController: ConfirmPhotoViewController?
    var dataStore: ConfirmPhotoDataStore?

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

    //func navigateToSomewhere(source: ConfirmPhotoViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    //func passDataToSomewhere(source: ConfirmPhotoDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
