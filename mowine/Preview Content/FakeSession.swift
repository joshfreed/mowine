//
//  Fakes.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import Combine
import Model

class FakeSession: Session {
    private var userId: UserId?
    private var emailAddress: String?
    private var _photoUrl: URL?

    func setUser(userId: UserId, email: String) {
        self.userId = userId
        self.emailAddress = email
    }

    func clearUser() {
        userId = nil
        emailAddress = nil
    }

    // MARK: Session

    var currentUserId: UserId? { _currentUserId.value }
    var isAnonymous = false

    var _currentUserId = CurrentValueSubject<UserId?, Never>(nil)
    var currentUserIdPublisher: AnyPublisher<UserId?, Never> { _currentUserId.eraseToAnyPublisher() }

    var _authStateDidChange = PassthroughSubject<AuthState, Never>()
    var authStateDidChange: AnyPublisher<AuthState, Never> { _authStateDidChange.eraseToAnyPublisher() }

    func start() {
        if let userId = userId {
            _authStateDidChange.send(AuthState(userId: userId, isAnonymous: false))
            _currentUserId.send(userId)
        } else {
            _authStateDidChange.send(AuthState())
            _currentUserId.send(nil)
        }
    }

    func startAnonymous() async throws {
        userId = UserId()
        _authStateDidChange.send(AuthState(userId: userId, isAnonymous: false))
        _currentUserId.send(userId)
    }
    
    func end() {
        clearUser()
        _authStateDidChange.send(AuthState())
        _currentUserId.send(nil)
        _photoUrl = nil
    }

    func getCurrentAuth() -> MoWineAuth? {
        FakeMoWineAuth(email: emailAddress)
    }

    func setPhotoUrl(_ url: URL, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        _photoUrl = url
        completion(.success(()))
    }

    func getPhotoUrl() -> URL? {
        _photoUrl
    }

    func reauthenticate(withEmail email: String, password: String) async throws {}
    
    func updateEmailAddress(_ emailAddress: String) async throws {}
}

struct FakeMoWineAuth: MoWineAuth {
    var email: String?
}

class FakeEmailAuth: EmailAuthenticationService {
    func signIn(emailAddress: String, password: String) async throws {}
    
    func signUp(emailAddress: String, password: String) async throws {}

    func forgotPassword(emailAddress: String) async throws {}
}

class FakeUserImageStorage: UserImageStorage {
    func putImage(userId: UserId, data: Data) async throws -> URL {
        URL(string: "https://google.com")!
    }
}
