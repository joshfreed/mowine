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
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (authResult, error) in
            switch error {
            case .some(let error as NSError) where error.code == AuthErrorCode.emailAlreadyInUse.rawValue:
                completion(.failure(EmailAuthenticationErrors.emailAddressAlreadyInUse))
            case .some(let error as NSError) where error.code == AuthErrorCode.weakPassword.rawValue:
                let reason = error.userInfo[NSLocalizedFailureReasonErrorKey] as? String
                completion(.failure(EmailAuthenticationErrors.invalidPassword(message: reason)))
            case .some(let error):
                SwiftyBeaver.error("\(error)")
                SwiftyBeaver.error(error.localizedDescription)
                completion(.failure(error))
            case .none:
                if let user = authResult?.user {
                    SwiftyBeaver.info("User signed up with firebase")
                    SwiftyBeaver.debug(user.uid)
                    completion(.success(()))
                } else {
                    fatalError("No error or user set in auth createUser(withEmail:password:)")
                }
            }
        }
    }
}
