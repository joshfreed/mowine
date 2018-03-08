//
//  SignInRouter.swift
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

@objc protocol SignInRoutingLogic {
    func routeToMyAccount()
    func routeToFriends()
}

protocol SignInDataPassing {
    var dataStore: SignInDataStore? { get }
}

class SignInRouter: NSObject, SignInRoutingLogic, SignInDataPassing {
    weak var viewController: SignInViewController?
    var dataStore: SignInDataStore?

    // MARK: Routing

    func routeToMyAccount() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController")
        navigateToMyAccount(source: viewController!, destination: destinationVC)
    }
    
    func routeToFriends() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "FriendsViewController")
        navigateToFriends(source: viewController!, destination: destinationVC)
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

    func navigateToMyAccount(source: SignInViewController, destination: UIViewController)
    {
        let nc = viewController?.navigationController
        nc?.popToRootViewController(animated: false)
        nc?.pushViewController(destination, animated: true)
    }
    
    func navigateToFriends(source: SignInViewController, destination: UIViewController)
    {
        let nc = viewController?.navigationController
        nc?.popToRootViewController(animated: false)
        nc?.pushViewController(destination, animated: true)
    }

    // MARK: Passing data

    //func passDataToSomewhere(source: SignInDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
