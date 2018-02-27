//
//  Session.swift
//  mowine
//
//  Created by Josh Freed on 2/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

protocol Session {
    var isLoggedIn: Bool { get }
}

class FakeSession: Session {
    private var _isLoggedIn = false
    
    var isLoggedIn: Bool {
        return _isLoggedIn
    }
    
    func notLoggedIn() {
        _isLoggedIn = false
    }
    
    func loggedIn() {
        _isLoggedIn = true
    }
}
