//
//  UserProfileRouter.swift
//  mowine
//
//  Created by Josh Freed on 3/13/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol UserProfileRoutingLogic {
    func routeToTopWines(segue: UIStoryboardSegue)
    func routeToWineCellar(segue: UIStoryboardSegue)
}

protocol UserProfileDataPassing {
    var dataStore: UserProfileDataStore? { get }
}

class UserProfileRouter: NSObject, UserProfileRoutingLogic, UserProfileDataPassing {
    weak var viewController: UserProfileViewController?
    var dataStore: UserProfileDataStore?

    // MARK: Routing

    func routeToTopWines(segue: UIStoryboardSegue) {
        print("routeToTopWines")
        let destinationVC = segue.destination as! TopWinesViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToTopWines(source: dataStore!, destination: &destinationDS)
    }
    
    func routeToWineCellar(segue: UIStoryboardSegue) {
        print("routeToWineCellar")
        let destinationVC = segue.destination as! WineCellarViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToWineCellar(source: dataStore!, destination: &destinationDS)
    }

    // MARK: Navigation

    //func navigateToSomewhere(source: UserProfileViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}

    // MARK: Passing data

    func passDataToTopWines(source: UserProfileDataStore, destination: inout TopWinesDataStore)
    {
        destination.userId = source.userId
    }
    
    func passDataToWineCellar(source: UserProfileDataStore, destination: inout WineCellarDataStore) {
        destination.userId = source.userId
    }
}
