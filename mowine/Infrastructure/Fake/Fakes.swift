//
//  Fakes.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

let usersDB: [User] = [
    User(id: UUIDUserId(), emailAddress: "josh@jpfreed.com", firstName: "Josh", lastName: "Freed"),
    User(id: UUIDUserId(), emailAddress: "bjones@test.com", firstName: "Barry", lastName: "Jones"),
    User(id: UUIDUserId(), emailAddress: "mshockley13@gmail.com", firstName: "Maureen", lastName: "Shockley"),
    User(id: UUIDUserId(), emailAddress: "test1@test.com", firstName: "Test", lastName: "User1"),
]

let friendsDB: [UUIDUserId: [UUIDUserId]] = [
    (usersDB[0].id as! UUIDUserId): [
        usersDB[1].id as! UUIDUserId,
        usersDB[2].id as! UUIDUserId
    ],
    (usersDB[2].id as! UUIDUserId): [
        usersDB[0].id as! UUIDUserId
    ]
]

class FakeSession: Session {
    private var _isLoggedIn = false
    
    var isLoggedIn: Bool {
        return _isLoggedIn
    }
    
    private var _currentUser: User?
    
    var currentUserId: UserId? {
        return _currentUser?.id
    }
    
    func notLoggedIn() {
        _isLoggedIn = false
        UserDefaults.standard.set(_isLoggedIn, forKey: "loggedIn")
    }
    
    func loggedIn() {
        _isLoggedIn = true
        UserDefaults.standard.set(_isLoggedIn, forKey: "loggedIn")
    }
    
    func setUser(user: User) {
        _currentUser = user
        UserDefaults.standard.set(user.emailAddress, forKey: "emailAddress")
        loggedIn()
    }
    
    func resume() {
        _isLoggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        if let emailAddress = UserDefaults.standard.value(forKey: "emailAddress") as? String {
            _currentUser = usersDB.first(where: { $0.emailAddress == emailAddress })
        } else {
            UserDefaults.standard.set(false, forKey: "loggedIn")
            _isLoggedIn = false
        }
    }
    
    func getCurrentUser(completion: @escaping (Result<User>) -> ()) {
        if let currentUser = _currentUser {
            completion(.success(currentUser))
        }
    }
}

class FakeEmailAuth: EmailAuthenticationService {
    func signIn(emailAddress: String, password: String, completion: @escaping (Result<Bool>) -> ()) {
        if let user = usersDB.first(where: { $0.emailAddress == emailAddress }) {
            (Container.shared.session as? FakeSession)?.setUser(user: user)
            completion(.success(true))
        } else {
            completion(.success(false))
        }
    }
}

class FakeUserRepository: UserRepository {
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        let friendIds = friendsDB[userId as! UUIDUserId] ?? []
        var friends: [User] = []
        for friendId in friendIds {
            if let friend = usersDB.first(where: { ($0.id as! UUIDUserId) == friendId }) {
                friends.append(friend)
            }
        }
        completion(.success(friends))
    }
}
