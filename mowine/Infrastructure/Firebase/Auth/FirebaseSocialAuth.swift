//
//  FirebaseSocialAuth.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseSocialAuth {
    func signIn(with credential: AuthCredential, completion: @escaping (Result<Void, Error>) -> ()) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(()))
        }
    }
}

extension FirebaseSocialAuth: FacebookAuthenticationService {
    func linkFacebookAccount(token: String, completion: @escaping (Result<Void, Error>) -> ()) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        signIn(with: credential, completion: completion)
    }
}

extension FirebaseSocialAuth: GoogleAuthenticationService {
    func linkGoogleAccount(idToken: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> ()) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        signIn(with: credential, completion: completion)
    }
}

extension FirebaseSocialAuth: AppleAuthenticationService {
    func linkAppleAccount(token: AppleToken, completion: @escaping (Result<Void, Error>) -> ()) {
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: token.idTokenString,
                                                  rawNonce: token.nonce)
        signIn(with: credential, completion: completion)
    }
}
