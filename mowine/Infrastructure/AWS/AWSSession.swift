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
    
    var identityId: String? {
        return AWSIdentityManager.default().identityId
    }
    
    var isLoggedIn: Bool {
        return AWSSignInManager.sharedInstance().isLoggedIn
    }
    
    var currentUserId: UserId? {
        printIds()
        return _currentUser?.id
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
    
    func getCurrentUser(completion: @escaping (Result<User>) -> ()) {
        printIds()
    }
    
    func end() {        
        AWSSignInManager.sharedInstance().logout { (result, error) in
            print("Logged out. \(AWSSignInManager.sharedInstance().isLoggedIn)")
        }
    }
    
    private func printIds() {
        let id = AWSIdentityManager.default().identityId
        let credProv = AWSMobileClient.sharedInstance().getCredentialsProvider()
        let identityId = credProv.identityId
        print("Credentials Provider Identity ID: \(String(describing: identityId))")
        print("Identity Manager ID: \(String(describing: id))")
        
        credProv.getIdentityId().continueWith { task -> Any? in
            if let e = task.error {
                let error = e as NSError
                print("\(error)")
            } else {
                let cognitoId = task.result!
                print("ASYNC Cognito id: \(cognitoId)")
            }
            return task
        }
    }
}
