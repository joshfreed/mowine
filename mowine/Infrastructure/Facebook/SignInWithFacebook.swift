//
//  SignInWithFacebook.swift
//  mowine
//
//  Created by Josh Freed on 12/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Model
import MoWine_Domain

struct FacebookToken: SocialToken {
    let token: String
}

class SignInWithFacebook: SocialSignInMethod {
    let login = LoginManager()
    
    func signIn(completion: @escaping (Result<SocialToken, Error>) -> Void) {
        login.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result, !result.isCancelled, let token = result.token {
                completion(.success(FacebookToken(token: token.tokenString)))
            }
        }
    }

    func signIn() async throws -> SocialToken {
        return try await withCheckedThrowingContinuation { cont in
            signIn()  { res in
                cont.resume(with: res)
            }
        }
    }

}
