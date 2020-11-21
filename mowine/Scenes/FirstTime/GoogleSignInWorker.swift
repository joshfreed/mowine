//
//  GoogleSignInWorker.swift
//  mowine
//
//  Created by Josh Freed on 3/23/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import GoogleSignIn
import SwiftyBeaver

struct GoogleToken: SocialToken {
    let idToken: String
    let accessToken: String
}

enum CreateUserFromGoogleInfoError: Error {
    case failedToFetchProfile
}

class GoogleProvider: SocialSignInProvider {
    let googleAuth: GoogleAuthenticationService
    
    init(googleAuth: GoogleAuthenticationService) {
        self.googleAuth = googleAuth
    }
    
    func linkAccount(token: GoogleToken, completion: @escaping (Result<Void, Error>) -> ()) {
        googleAuth.linkGoogleAccount(idToken: token.idToken, accessToken: token.accessToken, completion: completion)
    }
    
    func getNewUserInfo(completion: @escaping (Result<NewUserInfo, Error>) -> ()) {
        guard let profile = GIDSignIn.sharedInstance()?.currentUser.profile else {
            completion(.failure(CreateUserFromGoogleInfoError.failedToFetchProfile))
            return
        }
        
        let newUserInfo = NewUserInfo(email: profile.email, firstName: profile.givenName, lastName: profile.familyName)
        
        completion(.success(newUserInfo))
    }
    
    func getProfilePictureUrl(_ urlString: String) -> String {
        return urlString
    }
}
