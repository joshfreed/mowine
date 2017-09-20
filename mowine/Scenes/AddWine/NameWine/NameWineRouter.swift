//
//  NameWineRouter.swift
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

@objc protocol NameWineRoutingLogic {
    func routeToRateWine(segue: UIStoryboardSegue)
}

protocol NameWineDataPassing {
    var dataStore: NameWineDataStore? { get }
}

class NameWineRouter: NSObject, NameWineRoutingLogic, NameWineDataPassing {
    weak var viewController: NameWineViewController?
    var dataStore: NameWineDataStore?

    // MARK: Routing

    func routeToRateWine(segue: UIStoryboardSegue)
    {
        let destinationVC = segue.destination as! RateWineViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToRateWine(source: dataStore!, destination: &destinationDS)    
    }

    // MARK: Navigation

    //func navigateToSomewhere(source: NameWineViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    func passDataToRateWine(source: NameWineDataStore, destination: inout RateWineDataStore)
    {
        destination.wineType = source.wineType
        destination.variety = source.variety
        destination.photo = source.photo
        destination.name = source.name
    }
}