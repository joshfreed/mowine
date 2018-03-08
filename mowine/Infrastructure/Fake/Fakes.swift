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
    User(id: UserId(), emailAddress: "josh@jpfreed.com", firstName: "Josh", lastName: "Freed"),
    User(id: UserId(), emailAddress: "bjones@test.com", firstName: "Barry", lastName: "Jones"),
    User(id: UserId(), emailAddress: "mshockley13@gmail.com", firstName: "Maureen", lastName: "Shockley"),
    User(id: UserId(), emailAddress: "mbananas@gmail.com", firstName: "Maurice", lastName: "Bananas"),
    User(id: UserId(), emailAddress: "test1@test.com", firstName: "Test", lastName: "User1"),
    User(id: UserId(), emailAddress: "test2@test.com", firstName: "Test", lastName: "User2"),
    User(id: UserId(), emailAddress: "test3@test.com", firstName: "Test", lastName: "User3"),
    User(id: UserId(), emailAddress: "test4@test.com", firstName: "Test", lastName: "User4"),
    User(id: UserId(), emailAddress: "test5@test.com", firstName: "Test", lastName: "User5"),
    User(id: UserId(), emailAddress: "test6@test.com", firstName: "Test", lastName: "User6"),
    User(id: UserId(), emailAddress: "test7@test.com", firstName: "Test", lastName: "User7"),
    User(id: UserId(), emailAddress: "test8@test.com", firstName: "Test", lastName: "User8"),
    User(id: UserId(), emailAddress: "test9@test.com", firstName: "Test", lastName: "User9"),
    User(id: UserId(), emailAddress: "test10@test.com", firstName: "Test", lastName: "User10"),
    User(id: UserId(), emailAddress: "test11@test.com", firstName: "Test", lastName: "User12"),
    User(id: UserId(), emailAddress: "test12@test.com", firstName: "Test", lastName: "User13"),
    User(id: UserId(), emailAddress: "test13@test.com", firstName: "Test", lastName: "User14"),
    User(id: UserId(), emailAddress: "test14@test.com", firstName: "Test", lastName: "User15"),
    User(id: UserId(), emailAddress: "test15@test.com", firstName: "Test", lastName: "User16"),
    User(id: UserId(), emailAddress: "test16@test.com", firstName: "Test", lastName: "User17"),
    User(id: UserId(), emailAddress: "test17@test.com", firstName: "Test", lastName: "User18"),
    User(id: UserId(), emailAddress: "test18@test.com", firstName: "Test", lastName: "User19"),
    User(id: UserId(), emailAddress: "test19@test.com", firstName: "Test", lastName: "User19"),
    User(id: UserId(), emailAddress: "test20@test.com", firstName: "Test", lastName: "User20"),
]

var friendsDB: [UserId: [UserId]] = [
    usersDB[0].id: [
        usersDB[1].id,
        usersDB[2].id
    ],
    usersDB[2].id: [
        usersDB[0].id
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
    
    func end() {
        _isLoggedIn = false
        _currentUser = nil
        UserDefaults.standard.removeObject(forKey: "emailAddress")
        UserDefaults.standard.removeObject(forKey: "loggedIn")
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
        let friendIds = friendsDB[userId] ?? []
        var friends: [User] = []
        for friendId in friendIds {
            if let friend = usersDB.first(where: { $0.id == friendId }) {
                friends.append(friend)
            }
        }
        completion(.success(friends))
    }
    
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        let words = searchString.split(separator: " ")
        var matches: [User] = []
        
        for word in words {
            let m = usersDB.filter {
                let firstName = $0.firstName ?? ""
                let lastName = $0.lastName ?? ""
                return firstName.starts(with: word) || lastName.starts(with: word)
            }
            matches.append(contentsOf: m)
        }
        
        completion(.success(matches))
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        if friendsDB[owningUserId] == nil {
            friendsDB[owningUserId] = []
        }
        friendsDB[owningUserId]!.append(friendId)
        completion(.success)
    }
    
    func getUserById(_ id: UserId, completion: @escaping (Result<User?>) -> ()) {
        let user = usersDB.first(where: { $0.id == id })
        completion(.success(user))
    }
}
