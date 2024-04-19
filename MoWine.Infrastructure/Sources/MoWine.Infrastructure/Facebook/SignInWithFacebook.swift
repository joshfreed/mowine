//
//  SignInWithFacebook.swift
//  mowine
//
//  Created by Josh Freed on 12/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import MoWine_Application
import MoWine_Domain

struct FacebookToken: SocialToken {
    let token: String
}

public class SignInWithFacebook: SocialSignInMethod {
    let login = LoginManager()

    public init() {}

    private func signIn(completion: @escaping (Result<SocialToken, Error>) -> Void) {
        login.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result, !result.isCancelled, let token = result.token {
                completion(.success(FacebookToken(token: token.tokenString)))
            } else {
                completion(.failure(SocialSignInErrors.signInCancelled))
            }
        }
    }

    public func signIn() async throws -> SocialToken {
        return try await withCheckedThrowingContinuation { cont in
            Task { @MainActor in
                signIn()  { res in
                    cont.resume(with: res)
                }
            }
        }
    }

}
