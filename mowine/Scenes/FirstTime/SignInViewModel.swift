//
//  SignInViewModel.swift
//  mowine
//
//  Created by Josh Freed on 12/19/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import FBSDKLoginKit
import SwiftyBeaver
import GoogleSignIn

enum LoginType {
    case email
    case facebook
    case google
}

class SignInViewModel: NSObject, ObservableObject {
    @Published var isSigningIn: Bool = false
    @Published var isSignInError: Bool = false
    @Published var signInError: String = ""
    
    var onEmailSignIn: () -> Void = { }
    var onEmailSignUp: () -> Void = { }
    var onSocialSignInSuccess: () -> Void = { }
    
    let worker: FirstTimeWorker
    
    init(firstTimeWorker: FirstTimeWorker) {
        self.worker = firstTimeWorker
    }
    
    func continueWith(_ loginType: LoginType) {
        switch loginType {
        case .email: onEmailSignUp()
        case .facebook: continueWithFacebook()
        case .google: continueWithGoogle()
        }
    }
    
    // MARK: Email
    
    func signInWithEmail() {
        onEmailSignIn()
    }
    
    // MARK: Continue with Facebook
    
    func continueWithFacebook() {
        let login = LoginManager()
        login.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if let error = error {
                SwiftyBeaver.error("FB Error: \(error)")
                return
            }
            
            if let result = result, !result.isCancelled, let token = result.token {
                self.linkToFacebookLogin(fbToken: token.tokenString)
            }
        }
    }
    
    private func linkToFacebookLogin(fbToken: String) {
        isSigningIn = true
        worker.loginWithFacebook(token: fbToken, completion: socialSignInComplete)
    }
    
    // MARK: Continue with Google
    
    func continueWithGoogle() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()

    }
    
    func linkToGoogleLogin(idToken: String, accessToken: String) {
        isSigningIn = true
        worker.loginWithGoogle(idToken: idToken, accessToken: accessToken, completion: socialSignInComplete)
    }
    
    // MARK: Social Sign In
    
    func socialSignInComplete(result: Swift.Result<User, Error>) {
        isSigningIn = false
        
        switch result {
        case .success: onSocialSignInSuccess()
        case .failure(let error):
            SwiftyBeaver.error("\(error)")
            isSignInError = true
            signInError = error.localizedDescription
        }
    }
}

// MARK: - GIDSignInDelegate

extension SignInViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error as NSError? {
            SwiftyBeaver.error(error)
            guard error.code != -5 else {
                return
            }
            fatalError(error.localizedDescription)
        } else {
            self.linkToGoogleLogin(idToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
}
