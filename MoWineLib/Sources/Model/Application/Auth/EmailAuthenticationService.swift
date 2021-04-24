//
//  EmailAuthenticationService.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

public protocol EmailAuthenticationService {
    func signIn(emailAddress: String, password: String, completion: @escaping (Result<Void, Error>) -> ())
    func signUp(emailAddress: String, password: String, completion: @escaping (Result<Void, Error>) -> ())
}

/// Errors that can be raised when signing in or signing up by email address and password.
public enum EmailAuthenticationErrors: Error {
    
    // Log In Errors
    /// The user with the specified email address could not be found.
    case userNotFound
    /// The login attempt failed because the password was not correct.
    case notAuthorized
    
    // Sign Up Errors
    /// The password used for a new account does not meet the requirements.
    case invalidPassword(message: String?)
    /// The email address used for a new account is already in use by another account.
    case emailAddressAlreadyInUse
    
}
