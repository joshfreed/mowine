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

class AWSSession: Session {
    let userRepository: UserRepository
    private var _currentUser: User?
    
    var isLoggedIn: Bool {
        return AWSMobileClient.sharedInstance().isSignedIn
    }
    
    var currentUserId: UserId? {
        guard let identityId = AWSMobileClient.sharedInstance().identityId else {
            return nil
        }
        return UserId(string: identityId)
    }
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func resume(completion: @escaping (EmptyResult) -> ()) {
//        AWSContainer.shared.mobileAuth.getIdentityId(completion: completion))
    }
    
    func getCurrentUser(completion: @escaping (Result<User?>) -> ()) {
        guard let currentUserId = currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }
        
        userRepository.getUserById(currentUserId, completion: completion)
    }
    
    func end() {
        AWSMobileClient.sharedInstance().signOut()
    }

    func setPhotoUrl(_ url: URL, completion: @escaping (EmptyResult) -> ()) {

    }

    func getPhotoUrl() -> URL? {
        fatalError("getPhotoUrl() has not been implemented")
    }
}
