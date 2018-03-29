//
//  EmailAuthenticationService.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

protocol EmailAuthenticationService {
    func signIn(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ())
    func signUp(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ())
}

enum EmailAuthenticationErrors: Error {
    case invalidPassword(message: String?)
    case emailAddressAlreadyInUse
    case userNotFound
    case notAuthorized
}
