//
//  MockSession.swift
//  
//
//  Created by Josh Freed on 9/30/21.
//

import Foundation
import Model
import Combine
import MoWine_Domain

class MockSession: Session {
    var isAnonymous: Bool = false

    var _currentUserIdPub = CurrentValueSubject<UserId?, Never>(nil)

    var currentUserIdPublisher: AnyPublisher<UserId?, Never> {
        _currentUserIdPub.eraseToAnyPublisher()
    }

    var _authStateDidChange = PassthroughSubject<AuthState, Never>()

    var authStateDidChange: AnyPublisher<AuthState, Never> {
        _authStateDidChange.eraseToAnyPublisher()
    }

    private var _currentUser: User?
    var photoUrl: URL?

    var isLoggedIn: Bool {
        return _currentUser != nil
    }

    var _currentUserId: UserId?
    var currentUserId: UserId? {
        return _currentUserId ?? _currentUser?.id
    }

    func start() {}

    func startAnonymous() async throws {}

    func login(userId: UserId) {
        _currentUserId = userId
    }

    func login(user: User) {
        _currentUser = user
    }

    func getCurrentAuth() -> MoWineAuth? {
        if let currentUser = _currentUser {
            return MockAuth(email: currentUser.emailAddress)
        } else {
            return nil
        }
    }

    func getCurrentUser(completion: @escaping (Swift.Result<User, Error>) -> ()) {
        if let currentUser = _currentUser {
            completion(.success(currentUser))
        } else {
            // ??DF?DF?
        }
    }

    func end() {
        _currentUser = nil
    }

    func setPhotoUrl(_ url: URL, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        photoUrl = url
        completion(.success(()))
    }

    func getPhotoUrl() -> URL? {
        return photoUrl
    }

    func updateEmailAddress(_ emailAddress: String) async throws {}

    func reauthenticate(withEmail email: String, password: String) async throws {}
}

struct MockAuth: MoWineAuth {
    var email: String?
}
