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
import MoWine_Application
import FirebaseCrashlytics
import MoWine_Domain

struct GoogleToken: SocialToken {
    let idToken: String
    let accessToken: String
}

public class SignInWithGoogle: SocialSignInMethod {
    public init() {}

    @MainActor
    public func signIn() async throws -> SocialToken {
        guard let app = FirebaseApp.app() else {
            fatalError("No FirebaseApp configured")
        }

        guard let clientId = app.options.clientID else {
            fatalError("FirebaseApp does not have a Google Client ID set")
        }

        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let presentingViewController = windowScene.windows.first?.rootViewController
        else {
            fatalError("No rootViewController")
        }

        let signInConfig = GIDConfiguration.init(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = signInConfig

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)

            let user = result.user

            guard let idToken = user.idToken else {
                throw SocialSignInErrors.missingIdToken
            }

            let token = GoogleToken(idToken: idToken.tokenString, accessToken: user.accessToken.tokenString)

            return token
        } catch {
            if (error as NSError).code == GIDSignInError.canceled.rawValue {
                throw SocialSignInErrors.signInCancelled
            } else {
                throw error
            }
        }
    }
}
