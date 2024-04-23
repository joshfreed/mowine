//
//  FirebaseSession.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseAuth
import OSLog
import Combine
import MoWine_Application
import FirebaseCrashlytics
import MoWine_Domain

private let logger = Logger(category: .firebase)

public class FirebaseSession: Session {
    public var currentUserId: UserId? { authState.userId }
    
    public var isAnonymous: Bool { authState.isAnonymous }
    
    public var authStateDidChange: AnyPublisher<AuthState, Never> {
        authStateSubject
            .print("AuthStateDidChange")
            .eraseToAnyPublisher()
    }
    
    public var currentUserIdPublisher: AnyPublisher<UserId?, Never> {
        authStateDidChange
            .map { $0.userId }
            .print("CurrentUserId")
            .eraseToAnyPublisher()
    }
    
    private var authState = AuthState()
    private var authStateSubject = CurrentValueSubject<AuthState, Never>(AuthState())
    private var handler: AuthStateDidChangeListenerHandle?
    private var cancellables = Set<AnyCancellable>()

    public init() {}

    public func start() {
        logger.info("Starting session...")

        let auth = Auth.auth()

        if let handler = handler {
            auth.removeStateDidChangeListener(handler)
        }

        handler = auth.addStateDidChangeListener { [weak self] (auth, user) in
            logger.debug("addStateDidChangeListener \(auth), \(String(describing: user))")
            self?.updateAuthState(from: user)
        }

        NotificationCenter.default.publisher(for: .signedIn)
            .sink { [weak self] _ in self?.updateAuthState(from: Auth.auth().currentUser) }
            .store(in: &cancellables)
    }

    public func startAnonymous() async throws {
        let result = try await Auth.auth().signInAnonymously()
        updateAuthState(from: result.user)
    }

    public func getCurrentAuth() -> MoWineAuth? { Auth.auth().currentUser }

    public func reauthenticate(withEmail email: String, password: String) async throws {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        try await Auth.auth().currentUser?.reauthenticate(with: credential)
    }
    
    public func end() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            logger.error("Error signing out: \(signOutError)")
            Crashlytics.crashlytics().record(error: signOutError)
        }
    }

    public func setPhotoUrl(_ url: URL, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
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

    public func getPhotoUrl() -> URL? {
        guard let authUser = Auth.auth().currentUser else {
            return nil
        }

        return authUser.photoURL
    }

    public func updateEmailAddress(_ emailAddress: String) async throws {
        guard let authUser = Auth.auth().currentUser else {
            throw SessionError.notLoggedIn
        }

        logger.debug("User info: \(authUser.providerData)")
        logger.debug("Provider ID: \(authUser.providerID)")

        do {
            try await authUser.updateEmail(to: emailAddress)
        } catch {
            let nserror = error as NSError
            if nserror.code == AuthErrorCode.requiresRecentLogin.rawValue {
                throw SessionError.requiresRecentLogin
            } else {
                throw error
            }
        }
    }
}

extension FirebaseSession {
    func updateAuthState(from user: FirebaseAuth.User?) {
        if let user = user {
            logger.info("FireBase Session Info: \(String(describing: user.email)), \(String(describing: user.displayName))")
            let userId = UserId(string: user.uid)
            let isAnonymous = user.isAnonymous
            authState = AuthState(userId: userId, isAnonymous: isAnonymous)
            authStateSubject.send(authState)
        } else {
            logger.warning("No user")
            authState = AuthState(userId: nil, isAnonymous: true)
            authStateSubject.send(authState)
        }
    }
}

extension FirebaseAuth.User: MoWineAuth {}
