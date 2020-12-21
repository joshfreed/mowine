//
//  SignInWithGoogle.swift
//  mowine
//
//  Created by Josh Freed on 12/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import GoogleSignIn
import SwiftyBeaver

class SignInWithGoogle: NSObject, SocialSignInMethod, GIDSignInDelegate {
    private var completion: ((Result<SocialToken, Error>) -> Void)?
    
    func signIn(completion: @escaping (Result<SocialToken, Error>) -> Void) {
        self.completion = completion
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error as NSError? {
            SwiftyBeaver.error(error)
            guard error.code != -5 else {
                return
            }
            fatalError(error.localizedDescription)
        } else {
            let token = GoogleToken(idToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            completion?(.success(token))
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
}
