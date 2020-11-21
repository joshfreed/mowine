//
//  Facebook.swift
//  mowineTests
//
//  Created by Josh Freed on 3/29/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
@testable import mowine
import Nimble

class MockFacebookAuthService: FacebookAuthenticationService {
    var signInResult: Result<Void, Error>?
    func signInWillSucceed() {
        signInResult = .success(())
    }
    var signInCalled = false
    func linkFacebookAccount(token: String, completion: @escaping (Result<Void, Error>) -> ()) {
        signInCalled = true
        if let result = signInResult {
            completion(result)
        }
    }
}

class MockGoogleAuthService: GoogleAuthenticationService {
    func linkGoogleAccount(idToken: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> ()) {
        
    }
}

class MockFacebookGraphApi: GraphApi {
    var emailAddress: String?
    var firstName: String?
    var lastName: String?
    
    func setMe(emailAddress: String, firstName: String, lastName: String) {
        self.emailAddress = emailAddress
        self.firstName = firstName
        self.lastName = lastName
    }
    
    override func me(params: [String: String], completion: @escaping (Result<[String: Any], Error>) -> ()) {
        var response: [String: Any] = [:]
        if let email = emailAddress {
            response["email"] = email
        }
        if let firstName = firstName {
            response["first_name"] = firstName
        }
        if let lastName = lastName {
            response["last_name"] = lastName
        }
        completion(.success(response))
    }
}
