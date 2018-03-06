//
//  FriendsWorker.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import JFLib

class FriendsWorker {
    let userRepository: UserRepository
    let session: Session
    
    init(userRepository: UserRepository, session: Session) {
        self.userRepository = userRepository
        self.session = session
    }
    
    func fetchMyFriends(completion: @escaping (Result<[User]>) -> ()) {
        guard let currentUserId = session.currentUserId else {
            return
        }
        userRepository.getFriendsOf(userId: currentUserId, completion: completion)
    }
}
