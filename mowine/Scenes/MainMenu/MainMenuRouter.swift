//
//  MainMenuRouter.swift
//  mowine
//
//  Created by Josh Freed on 2/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

@objc protocol MainMenuRoutingLogic {
    func routeToAddWine(segue: UIStoryboardSegue)
    func routeToMyWines(segue: UIStoryboardSegue)
    func routeToMyAccount(segue: UIStoryboardSegue)
    func routeToFriends(segue: UIStoryboardSegue)
    func routeToSignInScreen(segue: UIStoryboardSegue)
}

class MainMenuRouter: NSObject, MainMenuRoutingLogic {
    weak var viewController: MainMenuViewController?
    
    // MARK: Routing
    
    func routeToAddWine(segue: UIStoryboardSegue)
    {
        
    }
    
    func routeToMyWines(segue: UIStoryboardSegue)
    {
        
    }
    
    func routeToMyAccount(segue: UIStoryboardSegue)
    {
        
    }
    
    func routeToFriends(segue: UIStoryboardSegue)
    {
        
    }
    
    func routeToSignInScreen(segue: UIStoryboardSegue)
    {
        let destinationVC = segue.destination as! SignInViewController
        var destinationDS = destinationVC.router!.dataStore!
        destinationDS.routeTo = viewController?.signInDestination ?? .myAccount
    }
    
    // MARK: Navigation
    
    // MARK: Passing data
    
}

