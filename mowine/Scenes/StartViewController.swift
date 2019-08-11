//
//  StartViewController.swift
//  mowine
//
//  Created by Josh Freed on 11/14/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseUI

class StartViewController: UIViewController, FirstTimeViewControllerDelegate, TabbedViewCoordinator {
    private var mainStoryboard: UIStoryboard!
    private var current: UIViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let current = current as? UINavigationController {
            if current.topViewController is MyAuthPickerViewController {
                return .default
            } else {
                return .lightContent
            }
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

        #if DEBUG
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(false)
        #else
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(true)
        #endif
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        if Auth.auth().currentUser == nil {
            showSignedOutView()
        } else {
            showSignedInView()
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
        
        /*
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth()
        ]
        authUI?.providers = providers
        authUI?.shouldHideCancelButton = true
        
        let authViewController = authUI!.authViewController()
        
        show(viewController: authViewController)
        */
    }
    
    private func show(viewController: UIViewController) {
        showChild(viewController)

        current?.willMove(toParent: nil)
        current?.view.removeFromSuperview()
        current?.removeFromParent()

        current = viewController
    }
}

extension StartViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        SwiftyBeaver.info("Did sign in! \(authDataResult), \(error)")
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let vc = MyAuthPickerViewController(authUI: authUI)
        return vc
    }
}
