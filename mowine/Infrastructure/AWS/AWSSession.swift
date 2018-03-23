//
//  AWSSession.swift
//  mowine
//
//  Created by Josh Freed on 3/22/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import AWSMobileClient
import AWSAuthCore

class AWSSession: Session {
    private var _currentUser: User?
    
    var isLoggedIn: Bool {
        return AWSSignInManager.sharedInstance().isLoggedIn
    }
    
    var currentUserId: UserId? {
        return _currentUser?.id
    }
    
    func resume(completion: @escaping (EmptyResult) -> ()) {
        completion(.success)
    }
    
    func getCurrentUser(completion: @escaping (Result<User>) -> ()) {
//        AWSIdentityManager.default().
    }
    
    func end() {        
        AWSSignInManager.sharedInstance().logout { (result, error) in
            
        }
    }
}
