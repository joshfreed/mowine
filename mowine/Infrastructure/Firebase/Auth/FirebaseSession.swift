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
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    var currentUserId: UserId? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        return UserId(string: uid)
    }
    
    func getCurrentUser(completion: @escaping (Result<User?>) -> ()) {
        if let authUser = Auth.auth().currentUser {
            let userId = UserId(string: authUser.uid)
            let user = User(id: userId, emailAddress: authUser.email ?? "")
            completion(.success(user))
        } else {
            completion(.success(nil))
        }
    }
    
    func end() {
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
}
