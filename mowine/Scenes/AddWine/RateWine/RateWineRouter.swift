//
//  RateWineRouter.swift
//  mowine
//
//  Created by Josh Freed on 9/20/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol RateWineRoutingLogic {
    func routeToAddWineSummary(segue: UIStoryboardSegue)
}

protocol RateWineDataPassing {
    var dataStore: RateWineDataStore? { get }
}

class RateWineRouter: NSObject, RateWineRoutingLogic, RateWineDataPassing {
    weak var viewController: RateWineViewController?
    var dataStore: RateWineDataStore?

    // MARK: Routing

    func routeToAddWineSummary(segue: UIStoryboardSegue)
    {
        let destinationVC = segue.destination as! AddWineSummaryViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToAddWineSummary(source: dataStore!, destination: &destinationDS)
    }

    // MARK: Navigation

    //func navigateToSomewhere(source: RateWineViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    func passDataToAddWineSummary(source: RateWineDataStore, destination: inout AddWineSummaryDataStore)
    {
        destination.wineType = source.wineType
        destination.variety = source.variety
        destination.photo = source.photo
        destination.name = source.name
        destination.rating = source.rating
    }
}
