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

        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                completion(.failure(error))
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
