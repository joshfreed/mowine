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

enum FriendsWorkerError: Error {
    case notLoggedIn
}

class FriendsWorker {
    let userRepository: UserRepository
    let session: Session
    
    init(userRepository: UserRepository, session: Session) {
        self.userRepository = userRepository
        self.session = session
    }
    
    func fetchMyFriends(completion: @escaping (Result<[User]>) -> ()) {
        guard let currentUserId = session.currentUserId else {
            completion(.failure(FriendsWorkerError.notLoggedIn))
            return
        }
        
        userRepository.getFriendsOf(userId: currentUserId, completion: completion)
    }
    
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        guard let currentUserId = session.currentUserId else {
            completion(.failure(FriendsWorkerError.notLoggedIn))
            return
        }
        
        guard !searchString.isEmpty else {
            completion(.success([]))
            return
        }
        
        userRepository.searchUsers(searchString: searchString) { result in
            switch result {
            case .success(let users):
                let usersWithoutCurrent = users.filter({ $0.id != currentUserId })
                completion(.success(usersWithoutCurrent))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func addFriend(userId: UserId, completion: @escaping (Result<User>) -> ()) {
        guard let currentUserId = session.currentUserId else {
            completion(.failure(FriendsWorkerError.notLoggedIn))
            return
        }

        userRepository.addFriend(owningUserId: currentUserId, friendId: userId, completion: completion)
    }

    func getUser(byId userId: UserId, completion: @escaping (Result<User?>) -> ()) {
        userRepository.getUserById(userId, completion: completion)
    }
}