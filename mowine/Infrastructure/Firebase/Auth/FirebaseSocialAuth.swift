//
//  FirebaseSocialAuth.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseSocialAuth: SocialAuthService {
    let credentialFactory: FirebaseCredentialMegaFactory

    init(credentialFactory: FirebaseCredentialMegaFactory) {
        self.credentialFactory = credentialFactory
    }

    func signIn(with token: SocialToken, completion: @escaping (Result<Void, Error>) -> ()) {
        let credential = credentialFactory.makeCredential(from: token)

        if let user = Auth.auth().currentUser, user.isAnonymous {
            link(user: user, with: credential, completion: completion)
        } else {
            signIn(with: credential, completion: completion)
        }
    }
    
    private func signIn(with credential: AuthCredential, completion: @escaping (Result<Void, Error>) -> ()) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    private func link(user: FirebaseAuth.User, with credential: AuthCredential, completion: @escaping (Result<Void, Error>) -> ()) {
        let duplicateAccountCodes = [
            AuthErrorCode.credentialAlreadyInUse.rawValue,
            AuthErrorCode.emailAlreadyInUse.rawValue
        ]
        
        user.link(with: credential) { (result, error) in
            if let error = error {
                let code = (error as NSError).code
                if duplicateAccountCodes.contains(code) {
                    self.switchToSignIn(with: credential, error: error, completion: completion)
                } else {
                    completion(.failure(error))
                }
            } else {
                completion(.success(()))
            }
        }
    }
    
    private func switchToSignIn(with credential: AuthCredential, error: Error, completion: @escaping (Result<Void, Error>) -> ()) {
        // An anonymous user provided valid credentials to an existing account.
        // That means this should be a sign in attempt for that account.
        // Note that this will clear any wines stored for the anonymous user. Perhaps one day I could consider merging.
        
        var _credential = credential
        
        if let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? AuthCredential {
            _credential = updatedCredential
        }
        
        signIn(with: _credential, completion: completion)
    }
    
    func reauthenticate(with token: SocialToken, completion: @escaping (Result<Void, Error>) -> ()) {
        let credential = credentialFactory.makeCredential(from: token)

        Auth.auth().currentUser?.reauthenticate(with: credential) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
