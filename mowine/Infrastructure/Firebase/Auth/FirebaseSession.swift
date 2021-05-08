//
//  FirebaseSession.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftyBeaver
import Combine
import Model

class FirebaseSession: Session {
    var currentUserId: UserId? {
        _currentUserId.value
    }
    
    var isAnonymous: Bool {
        Auth.auth().currentUser?.isAnonymous ?? false
    }
    
    var authStateDidChange: AnyPublisher<Void, Never> {
        _authStateDidChange
            .print("AuthStateDidChange")
            .eraseToAnyPublisher()
    }
    
    var currentUserIdPublisher: AnyPublisher<UserId?, Never> {
        _currentUserId
            .print("CurrentUserId")
            .eraseToAnyPublisher()
    }
    
    private var _authStateDidChange = PassthroughSubject<Void, Never>()
    private var _currentUserId = CurrentValueSubject<UserId?, Never>(nil)
    private var handler: AuthStateDidChangeListenerHandle?
    
    func start(completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        SwiftyBeaver.info("Starting session...")
        
        let auth = Auth.auth()

        if let handler = handler {
            auth.removeStateDidChangeListener(handler)
        }
        
        handler = auth.addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                SwiftyBeaver.info("FireBase Session Info: \(String(describing: user.email)), \(String(describing: user.displayName))")
                self?._currentUserId.send(UserId(string: user.uid))
            } else {
                SwiftyBeaver.warning("No user")
                self?._currentUserId.send(nil)
            }
            
            self?._authStateDidChange.send()
        }
        
        if auth.currentUser == nil {
            auth.signInAnonymously() { (authResult, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }                
            }
        } else {
            completion(.success(()))
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
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            SwiftyBeaver.error("Error signing out: \(signOutError)")
        }
        
        Auth.auth().signInAnonymously() { (_, _) in }
    }

    func setPhotoUrl(_ url: URL, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
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
                completion(.success(()))
            }
        }
    }

    func getPhotoUrl() -> URL? {
        guard let authUser = Auth.auth().currentUser else {
            return nil
        }

        return authUser.photoURL
    }

    func updateEmailAddress(_ emailAddress: String) -> Future<Void, Error> {
        Future { promise in
            guard let authUser = Auth.auth().currentUser else {
                promise(.failure(SessionError.notLoggedIn))
                return
            }
            
            SwiftyBeaver.debug("User info: \(authUser.providerData)")
            SwiftyBeaver.debug("Provider ID: \(authUser.providerID)")

            authUser.updateEmail(to: emailAddress) { error in
                if let error = error {
                    let nserror = error as NSError
                    if nserror.code == AuthErrorCode.requiresRecentLogin.rawValue {
                        promise(.failure(SessionError.requiresRecentLogin))
                    } else {
                        promise(.failure(error))
                    }
                } else {
                    promise(.success(()))
                }
            }
        }
    }
}

extension FirebaseAuth.User: MoWineAuth {

}
