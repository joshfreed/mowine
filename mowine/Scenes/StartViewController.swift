//
//  StartViewController.swift
//  mowine
//
//  Created by Josh Freed on 11/14/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import AWSMobileClient
import SwiftyBeaver
import Firebase
import FirebaseAuth
import GoogleSignIn

protocol StartViewControllerDelegate: class {
    func showSignedInView()
    func showSignedOutView()
}

class StartViewController: UIViewController, StartViewControllerDelegate {
    private var mainStoryboard: UIStoryboard!
    private var current: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        current = mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController")
        show(viewController: current!)
        
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        let handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            SwiftyBeaver.info("addStateDidChangeListener was triggered")
            if user != nil {
                self?.showSignedInView()
            } else {
                self?.showSignedOutView()
            }
        }
    }
    
    func showSignedInView() {
        let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        show(viewController: destinationVC)
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
