//
//  Session.swift
//  mowine
//
//  Created by Josh Freed on 2/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

protocol Session {
    var isLoggedIn: Bool { get }
    func resume()
    func getCurrentUser(completion: @escaping (Result<User>) -> ())
}

class FakeSession: Session {
    private var _isLoggedIn = false
    
    var isLoggedIn: Bool {
        return _isLoggedIn
    }
    
    func notLoggedIn() {
        _isLoggedIn = false
        UserDefaults.standard.set(_isLoggedIn, forKey: "loggedIn")
    }
    
    func loggedIn() {
        _isLoggedIn = true
        UserDefaults.standard.set(_isLoggedIn, forKey: "loggedIn")
    }
    
    func resume() {
        _isLoggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
    }
    
    func getCurrentUser(completion: @escaping (Result<User>) -> ()) {
        let user = User(firstName: "Josh", lastName: "Freed", emailAddress: "josh@jpfreed.com", profilePicture: nil)
        completion(.success(user))
    }
}
