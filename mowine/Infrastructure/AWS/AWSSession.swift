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
    let userRepository: UserRepository
    private var _currentUser: User?
    
    var identityId: String? {
        return AWSIdentityManager.default().identityId
    }
    
    var isLoggedIn: Bool {
        return AWSSignInManager.sharedInstance().isLoggedIn
    }
    
    var currentUserId: UserId? {
        guard let identityId = AWSIdentityManager.default().identityId else {
            return nil
        }
        return UserId(string: identityId)
    }
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func resume(completion: @escaping (EmptyResult) -> ()) {
//        AWSSignInManager.sharedInstance().resumeSession { (result, error) in
//            if let e = error {
//                print("\(e)")
//                completion(.failure(e))
//            } else {
//                print("resumeSession complete")
//                completion(.success)
//            }
//        }        
        completion(.success)
    }
    
    func getCurrentUser(completion: @escaping (Result<User?>) -> ()) {
        guard let currentUserId = currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }
        
        userRepository.getUserById(currentUserId, completion: completion)
    }
    
    func end() {        
        AWSSignInManager.sharedInstance().logout { (result, error) in
            print("Logged out. \(AWSSignInManager.sharedInstance().isLoggedIn)")
        }
    }
}
