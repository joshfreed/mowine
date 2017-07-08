//
//  SelectTypeRouter.swift
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

@objc protocol SelectTypeRoutingLogic {
    func routeToSelectVariety(segue: UIStoryboardSegue?)
}

protocol SelectTypeDataPassing {
    var dataStore: SelectTypeDataStore? { get }
}

class SelectTypeRouter: NSObject, SelectTypeRoutingLogic, SelectTypeDataPassing {
    weak var viewController: SelectTypeViewController?
    var dataStore: SelectTypeDataStore?

    // MARK: Routing

    func routeToSelectVariety(segue: UIStoryboardSegue?)
    {
        let destinationVC = segue?.destination as! SelectVarietyViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    }

    // MARK: Navigation

    // MARK: Passing data

    func passDataToSomewhere(source: SelectTypeDataStore, destination: inout SelectVarietyDataStore)
    {
        destination.wineType = source.selectedType
    }
}
