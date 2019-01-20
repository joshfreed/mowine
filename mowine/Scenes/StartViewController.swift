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

class StartViewController: UIViewController {
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
        
/*
        AWSMobileClient.sharedInstance().addUserStateListener(self) { userState, info in
            switch (userState) {
            case .guest:
                SwiftyBeaver.debug("user is in guest mode.")
            case .signedOut:
                SwiftyBeaver.debug("user signed out")
            case .signedIn:
                SwiftyBeaver.debug("user is signed in.")
                Container.shared.syncManager.sync()
            case .signedOutUserPoolsTokenInvalid:
                SwiftyBeaver.debug("need to login again.")
            case .signedOutFederatedTokensInvalid:
                SwiftyBeaver.debug("user logged in via federation, but currently needs new tokens")
            default:
                SwiftyBeaver.debug("unsupported")
            }
        }
        
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
//            Container.shared.session.resume { result in
//                switch result {
//                case .success: break
//                case .failure(let error): SwiftyBeaver.error("\(error)")
//                }
//            }
            
            if let userState = userState {
                SwiftyBeaver.debug("UserState: \(userState.rawValue)")
                SwiftyBeaver.debug("Current user id: \(Container.shared.session.currentUserId?.asString ?? "nil")")
                
                switch userState {
                case .signedIn: self.showSignedInView()
                case .signedOut: self.showSignedOutView()
                default:
                    break
                }
                
            } else if let error = error {
                SwiftyBeaver.debug("error: \(error.localizedDescription)")
            }
        }
*/
    }
    
    private func showSignedInView() {
        let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        show(viewController: destinationVC)
    }
    
    private func showSignedOutView() {
        let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
        let destinationVC = storyboard.instantiateInitialViewController()!
        show(viewController: destinationVC)
    }
    
    private func show(viewController: UIViewController) {
        showChild(viewController)

        current?.willMove(toParent: nil)
        current?.view.removeFromSuperview()
        current?.removeFromParent()

        current = viewController
    }
}
