//
//  FirebaseSession.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import FirebaseAuth
import SwiftyBeaver

class FirebaseSession: Session {
    let userRepository: UserRepository
    private var currentUser: User?

    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    var currentUserId: UserId? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        return UserId(string: uid)
    }

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func end() {
        currentUser = nil        
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            SwiftyBeaver.error("Error signing out: \(signOutError)")
        }
    }

    func setPhotoUrl(_ url: URL, completion: @escaping (EmptyResult) -> ()) {
        guard let authUser = Auth.auth().currentUser else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }

        let changeRequest = authUser.createProfileChangeRequest()
        changeRequest.photoURL = url
        changeRequest.commitChanges { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success)
            }
        }
    }

    func getPhotoUrl() -> URL? {
        guard let authUser = Auth.auth().currentUser else {
            return nil
        }

        return authUser.photoURL
    }

    func getCurrentUser(completion: @escaping (Result<User>) -> ()) {
        if let currentUser = currentUser {
            completion(.success(currentUser))
            return
        }

        fetchUserModel(completion: completion)
    }

    private func fetchUserModel(completion: @escaping (Result<User>) -> ()) {
        guard let currentUserId = currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }

        userRepository.getUserById(currentUserId) { result in
            switch result {
            case .success(let user):
                if let user = user {
                    self.currentUser = user
                    completion(.success(user))
                } else {
                    fatalError("No user found matching the id of the current user \(currentUserId)")
                }
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
