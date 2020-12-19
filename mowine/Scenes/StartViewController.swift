//
//  StartViewController.swift
//  mowine
//
//  Created by Josh Freed on 11/14/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver

class StartViewController: UIViewController, FirstTimeViewControllerDelegate, TabbedViewCoordinator {
    var session: Session!
    
    private var mainStoryboard: UIStoryboard!
    private var current: UIViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if (current as? UINavigationController) != nil {
            return .lightContent
        } else if let current = current as? TabBarViewController {
            return current.preferredStatusBarStyle
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        current = mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController")
        show(viewController: current!)
        
        if session.isLoggedIn {
            showSignedInView()
        } else {
            showSignedOutView()
        }
    }
    
    func showSignedInView() {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        vc.coordinator = self
        show(viewController: vc)
    }
    
    func showSignedOutView() {
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let nc = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nc.topViewController as! FirstTimeViewController
        vc.delegate = self
        show(viewController: nc)
    }
    
    private func show(viewController: UIViewController) {
        showChild(viewController)

        current?.willMove(toParent: nil)
        current?.view.removeFromSuperview()
        current?.removeFromParent()

        current = viewController
    }
}
