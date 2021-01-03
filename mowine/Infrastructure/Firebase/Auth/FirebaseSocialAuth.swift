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
        user.link(with: credential) { (result, error) in
            if let error = error {
                if (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
                    // An anonymous user provided valid credentials to an existing account.
                    // This is a sign-in attempt.
                    // Note that this will clear any wines stored for the anonymous user. Perhaps one day I could consider merging.
                    self.signIn(with: credential, completion: completion)
                } else {
                    completion(.failure(error))
                }
            } else {
                completion(.success(()))
            }
        }
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
