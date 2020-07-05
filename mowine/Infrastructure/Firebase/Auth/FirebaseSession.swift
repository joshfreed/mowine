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
import FirebaseFirestore
import PromiseKit

class FirebaseSession: Session {
    let userRepository: UserRepository
   
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    var currentUserId: UserId? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        return UserId(string: uid)
    }
    
    private var currentUser: User?
    private var listener: MoWineListenerRegistration?

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.listenForUserUpdates()
                SwiftyBeaver.info("FireBase Session Info: \(user?.email), \(user?.displayName)")
            }
        }
    }
    
    private func listenForUserUpdates() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let currentUserId = UserId(string: uid)
        
        SwiftyBeaver.info("Listening for changes to User \(currentUserId)")
        
        listener?.remove()
        listener = nil
        
        listener = userRepository.getUserByIdAndListenForUpdates(id: currentUserId) { result in
            if case let .success(user) = result {
                SwiftyBeaver.debug("Updating session current user!")
                self.currentUser = user
            }
        }
    }

    func getCurrentAuth() -> MoWineAuth? { Auth.auth().currentUser }

    func reauthenticate(withEmail email: String, password: String, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        Auth.auth().currentUser?.reauthenticate(with: credential) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
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

    func updateEmailAddress(_ emailAddress: String) -> Promise<Void> {
        return Promise<Void> { seal in
            guard let authUser = Auth.auth().currentUser else {
                seal.reject(SessionError.notLoggedIn)
                return
            }
            
            SwiftyBeaver.debug("User info: \(authUser.providerData)")
            SwiftyBeaver.debug("Provider ID: \(authUser.providerID)")

            authUser.updateEmail(to: emailAddress) { error in
                if let error = error {
                    let nserror = error as NSError
                    if nserror.code == AuthErrorCode.requiresRecentLogin.rawValue {
                        seal.reject(SessionError.requiresRecentLogin)
                    } else {
                        seal.reject(error)
                    }
                } else {
                    seal.fulfill_()
                }
            }
        }
    }
}

extension FirebaseAuth.User: MoWineAuth {

}
