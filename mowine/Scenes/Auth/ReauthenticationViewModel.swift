//
//  ReauthenticationViewModel.swift
//  mowine
//
//  Created by Josh Freed on 12/6/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ReauthenticationViewModel: NSObject, ObservableObject {
    @Published var showEmailReauth = false
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    
    var onSuccess: () -> Void
    var onCancel: () -> Void
    
    init(onSuccess: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.onSuccess = onSuccess
        self.onCancel = onCancel
    }
    
    func cancel() {
        onCancel()
    }
    
    func continueWith(_ loginType: LoginType) {
        switch loginType {
        case .email: continueWithEmail()
        case .facebook: continueWithFacebook()
        case .google: continueWithGoogle()
        }
    }
    
    // MARK: Email
    
    private func continueWithEmail() {
        showEmailReauth = true
    }
    
    // MARK: Login Providers
    
    private func continueWithFacebook() {
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
    
    private func continueWithGoogle() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    private func reauthenticate(with credential: AuthCredential) {
        Auth.auth().currentUser?.reauthenticate(with: credential) { [weak self] (result, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                self?.errorMessage = error.localizedDescription
                self?.showErrorAlert = true
            } else {
                self?.onSuccess()
            }
        }
    }
    
    // MARK: View Model Factories
    
    func makeEmailReauthViewModel() -> EmailReauthViewModel {
        EmailReauthViewModel(session: JFContainer.shared.session, onSuccess: onSuccess)
    }
}

// MARK: - GIDSignInDelegate

extension ReauthenticationViewModel: GIDSignInDelegate {
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
