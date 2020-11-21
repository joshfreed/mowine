//
//  EmailAuthenticationService.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

protocol EmailAuthenticationService {
    func signIn(emailAddress: String, password: String, completion: @escaping (Result<Void, Error>) -> ())
    func signUp(emailAddress: String, password: String, completion: @escaping (Result<Void, Error>) -> ())
}

enum EmailAuthenticationErrors: Error {
    case invalidPassword(message: String?)
    case emailAddressAlreadyInUse
    case userNotFound
    case notAuthorized
}
