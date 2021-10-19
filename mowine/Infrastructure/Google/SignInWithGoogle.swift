//
//  SignInWithGoogle.swift
//  mowine
//
//  Created by Josh Freed on 12/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import SwiftyBeaver
import Model
import FirebaseCrashlytics
import MoWine_Domain

struct GoogleToken: SocialToken {
    let idToken: String
    let accessToken: String
}

class SignInWithGoogle: SocialSignInMethod {
    func signIn(completion: @escaping (Result<SocialToken, Error>) -> Void) {
        guard let app = FirebaseApp.app() else {
            fatalError("No FirebaseApp configured")
        }
        guard let clientId = app.options.clientID else {
            fatalError("FirebaseApp does not have a Google Client ID set")
        }

        let signInConfig = GIDConfiguration.init(clientID: clientId)

        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            fatalError("No rootViewController")
        }

        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: presentingViewController) { user, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = user else {
                completion(.failure(SocialSignInErrors.googleUserNotFound))
                return
            }
            
            guard let idToken = user.authentication.idToken else {
                completion(.failure(SocialSignInErrors.missingIdToken))
                return
            }

            let token = GoogleToken(idToken: idToken, accessToken: user.authentication.accessToken)

            completion(.success(token))
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
