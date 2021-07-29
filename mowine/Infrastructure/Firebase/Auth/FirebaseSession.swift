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
import FirebaseCrashlytics

class FirebaseSession: Session {
    var currentUserId: UserId? { authState.userId }
    
    var isAnonymous: Bool { authState.isAnonymous }
    
    var authStateDidChange: AnyPublisher<AuthState, Never> {
        authStateSubject
            .print("AuthStateDidChange")
            .eraseToAnyPublisher()
    }
    
    var currentUserIdPublisher: AnyPublisher<UserId?, Never> {
        authStateDidChange
            .map { $0.userId }
            .print("CurrentUserId")
            .eraseToAnyPublisher()
    }
    
    private var authState = AuthState()
    private var authStateSubject = CurrentValueSubject<AuthState, Never>(AuthState())
    private var handler: AuthStateDidChangeListenerHandle?
    private var cancellables = Set<AnyCancellable>()

    func start() {
        SwiftyBeaver.info("Starting session...")

        let auth = Auth.auth()

        if let handler = handler {
            auth.removeStateDidChangeListener(handler)
        }

        handler = auth.addStateDidChangeListener { [weak self] (auth, user) in
            self?.updateAuthState(from: user)
        }

        NotificationCenter.default.publisher(for: .signedIn)
            .sink { [weak self] _ in self?.updateAuthState(from: Auth.auth().currentUser) }
            .store(in: &cancellables)

        if auth.currentUser == nil {
            auth.signInAnonymously() { (authResult, error) in
                if let error = error {
                    SwiftyBeaver.error("\(error)")
                    Crashlytics.crashlytics().record(error: error)
                }
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

extension FirebaseSession {
    func updateAuthState(from user: FirebaseAuth.User?) {
        if let user = user {
            SwiftyBeaver.info("FireBase Session Info: \(String(describing: user.email)), \(String(describing: user.displayName))")
            let userId = UserId(string: user.uid)
            let isAnonymous = user.isAnonymous
            self.authState = AuthState(userId: userId, isAnonymous: isAnonymous)
            authStateSubject.send(authState)
        } else {
            SwiftyBeaver.warning("No user")
            self.authState = AuthState()
            authStateSubject.send(AuthState())
        }
    }
}

extension FirebaseAuth.User: MoWineAuth {}
