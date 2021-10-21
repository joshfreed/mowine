//
//  FirebaseSocialAuth.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth
import MoWine_Application
import MoWine_Domain

public class FirebaseSocialAuth: SocialAuthService {
    let credentialFactory: FirebaseCredentialMegaFactory

    public init(credentialFactory: FirebaseCredentialMegaFactory) {
        self.credentialFactory = credentialFactory
    }

    public func signIn(with token: SocialToken) async throws {
        let credential = credentialFactory.makeCredential(from: token)

        if let user = Auth.auth().currentUser, user.isAnonymous {
            try await link(user: user, with: credential)
        } else {
            try await signIn(with: credential)
        }
    }

    private func signIn(with credential: AuthCredential) async throws {
        try await Auth.auth().signIn(with: credential)
    }
    
    private func link(user: FirebaseAuth.User, with credential: AuthCredential) async throws {
        let duplicateAccountCodes = [
            AuthErrorCode.credentialAlreadyInUse.rawValue,
            AuthErrorCode.emailAlreadyInUse.rawValue
        ]

        do {
            try await user.link(with: credential)
        } catch {
            let code = (error as NSError).code
            if duplicateAccountCodes.contains(code) {
                try await switchToSignIn(with: credential, error: error)
            } else {
                throw error
            }
        }
    }
    
    private func switchToSignIn(with credential: AuthCredential, error: Error) async throws {
        // An anonymous user provided valid credentials to an existing account.
        // That means this should be a sign in attempt for that account.
        // Note that this will clear any wines stored for the anonymous user. Perhaps one day I could consider merging.
        
        var _credential = credential
        
        if let updatedCredential = (error as NSError).userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? AuthCredential {
            _credential = updatedCredential
        }
        
        try await signIn(with: _credential)
    }
    
    public func reauthenticate(with token: SocialToken) async throws {
        let credential = credentialFactory.makeCredential(from: token)
        try await Auth.auth().currentUser?.reauthenticate(with: credential)
    }
}
