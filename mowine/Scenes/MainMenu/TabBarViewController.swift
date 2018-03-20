//
//  TabBarViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/18/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    var session: Session!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        session = Container.shared.session
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is AddWineViewController {
            let storyboard = UIStoryboard(name: "AddWine", bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                present(vc, animated: true, completion: nil)
                return false
            }
        }
        
        if let nc = viewController as? UINavigationController, nc.topViewController is FriendsViewController, !session.isLoggedIn {
            openSignInModal(indexToSelectOnSuccess: 2)
            return false
        }
        
        if !session.isLoggedIn && viewController is MyAccountViewController {
            openSignInModal(indexToSelectOnSuccess: 3)
            return false
        }
        
        return true
    }
    
    // MARK: Helpers
    
    private func openSignInModal(indexToSelectOnSuccess newIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = storyboard.instantiateViewController(withIdentifier: "SignIn") as! UINavigationController
        let vc = nc.topViewController as! SignInViewController
        vc.onSignedIn = { [weak self] in
            self?.selectedIndex = newIndex
        }
        present(nc, animated: true, completion: nil)
    }
}
