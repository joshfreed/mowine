//
//  FirebaseSocialAuth.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth
import JFLib

class FirebaseSocialAuth {
    
}

extension FirebaseSocialAuth: FacebookAuthenticationService {
    func linkFacebookAccount(token: String, completion: @escaping (EmptyResult) -> ()) {
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success)
        }
    }
}

extension FirebaseSocialAuth: GoogleAuthenticationService {
    func linkGoogleAccount(idToken: String, accessToken: String, completion: @escaping (EmptyResult) -> ()) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success)
        }
    }
}
