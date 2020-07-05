//
//  ReauthenticationViewController.swift
//  mowine
//
//  Created by Josh Freed on 11/2/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

protocol ReauthenticationViewControllerDelegate: class {
    func reauthenticationSucceeded()
}

class ReauthenticationViewController: UIViewController {    
    weak var delegate: ReauthenticationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "continueWithEmail" {
            let vc = segue.destination as! EmailReauthViewController
            vc.delegate = self
        }
    }
        
    @IBAction func continueWithFacebook(_ sender: Any) {
        let login = LoginManager()
        login.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if let error = error {
                SwiftyBeaver.error("FB Error: \(error)")
                return
            }
            
            if let result = result, !result.isCancelled, let token = result.token {
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                self.reauthenticate(with: credential)
            }
        }
    }
    
    @IBAction func continueWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func continueWithEmail(_ sender: Any) {

    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func reauthenticate(with credential: AuthCredential) {
        Auth.auth().currentUser?.reauthenticate(with: credential) { (result, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                self.showAlert(error: error)
            } else {
                self.reauthenticationSucceeded()
            }
        }
    }
}

// MARK: - GIDSignInDelegate

extension ReauthenticationViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error as NSError? {
            SwiftyBeaver.error(error)
            guard error.code != -5 else {
                return
            }
            fatalError(error.localizedDescription)
        } else {
            let idToken = user.authentication.idToken!
            let accessToken = user.authentication.accessToken!
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            self.reauthenticate(with: credential)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
}

// MARK: - EmailReauthViewControllerDelegate

extension ReauthenticationViewController: EmailReauthViewControllerDelegate {
    func reauthenticationSucceeded() {
        dismiss(animated: true, completion: nil)
        delegate?.reauthenticationSucceeded()
    }
}
