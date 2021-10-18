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
    private var _isLoggedIn = false
    private var _photoUrl: URL?    
    private var _currentUser: User?
    
    var currentUserId: UserId? {
        return _currentUser?.id
    }
    
    var isAnonymous = false

    var _authStateDidChange = PassthroughSubject<AuthState, Never>()
    var authStateDidChange: AnyPublisher<AuthState, Never> {
        _authStateDidChange.eraseToAnyPublisher()
    }

    var _currentUserId = CurrentValueSubject<UserId?, Never>(nil)
    var currentUserIdPublisher: AnyPublisher<UserId?, Never> {
        _currentUserId.eraseToAnyPublisher()
    }

    func setUser(user: User) {
        _currentUser = user
        _isLoggedIn = true
    }
    
    func start() {
        _isLoggedIn = true
    }

    func startAnonymous() async throws {}
    
    func end() {
        _isLoggedIn = false
        _currentUser = nil
    }

    func getCurrentAuth() -> MoWineAuth? {
        return FakeMoWineAuth(email: "boobs@butts.com")
    }

    func reauthenticate(withEmail email: String, password: String) async throws {}

    func setPhotoUrl(_ url: URL, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        _photoUrl = url
        completion(.success(()))
    }

    func getPhotoUrl() -> URL? {
        return _photoUrl
    }
    
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
