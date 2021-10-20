//
//  FirebaseEmailAuth.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftyBeaver
import MoWine_Application
import MoWine_Domain

class FirebaseEmailAuth: EmailAuthenticationService {
    func signIn(emailAddress: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: emailAddress, password: password)
            SwiftyBeaver.info("User signed in with firebase")
            SwiftyBeaver.debug(authResult.user.uid)
        } catch let error {
            SwiftyBeaver.error("\(error)")
            switch (error as NSError).code {
            case AuthErrorCode.userNotFound.rawValue:
                throw EmailAuthenticationErrors.userNotFound
            case AuthErrorCode.wrongPassword.rawValue,
                 AuthErrorCode.invalidEmail.rawValue,
                 AuthErrorCode.userDisabled.rawValue:
                throw EmailAuthenticationErrors.notAuthorized
            default: throw error
            }
        }
    }
    
    func signUp(emailAddress: String, password: String) async throws {
        if let user = Auth.auth().currentUser, user.isAnonymous {
            // Link the current anonymous user with a username and password.
            try await doLink(user: user, emailAddress: emailAddress, password: password)
        } else {
            // In this case there is no auth user. This can happen if firebase automatically signs you out for some reason, like an invalid user token.
            // Instead of linking w/ the anonymous user this will just use createUser to create a fresh account.
            try await doCreateUser(emailAddress: emailAddress, password: password)
        }
    }

    private func doLink(user: FirebaseAuth.User, emailAddress: String, password: String) async throws {
        assert(user.isAnonymous, "Attempted to sign up but there is not an anonymous user logged in.")

        let credential = EmailAuthProvider.credential(withEmail: emailAddress, password: password)

        do {
            try await user.link(with: credential)
            SwiftyBeaver.info("Anonymous user has been converted into a real user /w email and password.")
            SwiftyBeaver.debug(user.uid)
        } catch {
            throw  signUpFailure(error)
        }
    }

    private func doCreateUser(emailAddress: String, password: String) async throws {
        SwiftyBeaver.warning("It appears there is no auth user. Falling back to createUser.")

        do {
            try await Auth.auth().createUser(withEmail: emailAddress, password: password)
            SwiftyBeaver.info("A fresh user has been created.")
        } catch {
            throw signUpFailure(error)
        }
    }

    
    private func signUpFailure(_ error: Error) -> Error {
        let nserror = error as NSError
        let code = nserror.code
        if code == AuthErrorCode.emailAlreadyInUse.rawValue {
            return EmailAuthenticationErrors.emailAddressAlreadyInUse
        } else if code == AuthErrorCode.weakPassword.rawValue {
            let reason = nserror.userInfo[NSLocalizedFailureReasonErrorKey] as? String
            return EmailAuthenticationErrors.invalidPassword(message: reason)
        } else {
            SwiftyBeaver.error("\(error)")
            SwiftyBeaver.error(error.localizedDescription)
            return error
        }
    }

    public func forgotPassword(emailAddress: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: emailAddress)
    }
}
