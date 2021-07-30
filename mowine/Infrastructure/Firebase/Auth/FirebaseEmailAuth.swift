//
//  FirebaseEmailAuth.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftyBeaver
import Model

class FirebaseEmailAuth: EmailAuthenticationService {
    func signIn(emailAddress: String, password: String, completion: @escaping (Result<Void, Error>) -> ()) {
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (authResult, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                switch (error as NSError).code {
                case AuthErrorCode.userNotFound.rawValue:
                    completion(.failure(EmailAuthenticationErrors.userNotFound))
                case AuthErrorCode.wrongPassword.rawValue,
                     AuthErrorCode.invalidEmail.rawValue,
                     AuthErrorCode.userDisabled.rawValue:
                    completion(.failure(EmailAuthenticationErrors.notAuthorized))
                default: completion(.failure(error))
                }
            } else if let user = authResult?.user {
                SwiftyBeaver.info("User signed in with firebase")
                SwiftyBeaver.debug(user.uid)
                completion(.success(()))
            } else {
                fatalError("No error or user set in auth signIn(withEmail:password:)")
            }
        }
    }
    
    func signUp(emailAddress: String, password: String, completion: @escaping (Result<Void, Error>) -> ()) {
        if let user = Auth.auth().currentUser, user.isAnonymous {
            /// Link the current anonymous user with a username and password.
            doLink(user: user, emailAddress: emailAddress, password: password, completion: completion)
        } else {
            /// In this case there is no auth user. This can happen if firebase automatically signs you out for some reason, like an invalid user token.
            /// Instead of linking w/ the anonymous user this will just use createUser to create a fresh account.
            doCreateUser(emailAddress: emailAddress, password: password, completion: completion)
        }
    }
    
    private func doLink(user: FirebaseAuth.User, emailAddress: String, password: String, completion: @escaping (Result<Void, Error>) -> ()) {
        assert(user.isAnonymous, "Attempted to sign up but there is not an anonymous user logged in.")

        let credential = EmailAuthProvider.credential(withEmail: emailAddress, password: password)
        
        user.link(with: credential) { (result, error) in
            if let error = error {
                completion(self.signUpFailure(error))
            } else {
                SwiftyBeaver.info("Anonymous user has been converted into a real user /w email and password.")
                SwiftyBeaver.debug(user.uid)
                completion(.success(()))
            }
        }
    }
    
    private func doCreateUser(emailAddress: String, password: String, completion: @escaping (Result<Void, Error>) -> ()) {
        SwiftyBeaver.warning("It appears there is no auth user. Falling back to createUser.")
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if let error = error {
                completion(self.signUpFailure(error))
            } else {
                SwiftyBeaver.info("A fresh user has been created.")
                completion(.success(()))
            }
        }
    }
    
    private func signUpFailure(_ error: Error) -> Result<Void, Error> {
        let nserror = error as NSError
        let code = nserror.code
        if code == AuthErrorCode.emailAlreadyInUse.rawValue {
            return .failure(EmailAuthenticationErrors.emailAddressAlreadyInUse)
        } else if code == AuthErrorCode.weakPassword.rawValue {
            let reason = nserror.userInfo[NSLocalizedFailureReasonErrorKey] as? String
            return .failure(EmailAuthenticationErrors.invalidPassword(message: reason))
        } else {
            SwiftyBeaver.error("\(error)")
            SwiftyBeaver.error(error.localizedDescription)
            return .failure(error)
        }
    }
}
