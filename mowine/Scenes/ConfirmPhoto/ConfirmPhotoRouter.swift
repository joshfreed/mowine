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
    func routeToNameAndRate(segue: UIStoryboardSegue)
}

protocol ConfirmPhotoDataPassing {
    var dataStore: ConfirmPhotoDataStore? { get }
}

class ConfirmPhotoRouter: NSObject, ConfirmPhotoRoutingLogic, ConfirmPhotoDataPassing {
    weak var viewController: ConfirmPhotoViewController?
    var dataStore: ConfirmPhotoDataStore?

    // MARK: Routing

    func routeToNameAndRate(segue: UIStoryboardSegue)
    {
        let destinationVC = segue.destination as! NameAndRateViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToNameAndRate(source: dataStore!, destination: &destinationDS)    
    }

    // MARK: Navigation

    //func navigateToSomewhere(source: ConfirmPhotoViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    func passDataToNameAndRate(source: ConfirmPhotoDataStore, destination: inout NameAndRateDataStore)
    {
        destination.wineType = source.wineType
        destination.variety = source.variety
        destination.photo = source.photo
    }
}