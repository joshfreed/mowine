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
    func signIn(emailAddress: String, password: String, completion: @escaping (Result<Bool>) -> ())
}

class FakeEmailAuth: EmailAuthenticationService {
    func signIn(emailAddress: String, password: String, completion: @escaping (Result<Bool>) -> ()) {
        (Container.shared.session as? FakeSession)?.loggedIn()
        completion(.success(true))
    }
}