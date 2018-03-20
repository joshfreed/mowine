//
//  Fakes.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

var josh = User(id: UserId(), emailAddress: "josh@jpfreed.com", firstName: "Josh", lastName: "Freed")
var maureen = User(id: UserId(), emailAddress: "mshockley13@gmail.com", firstName: "Maureen", lastName: "Shockley")

let usersDB: [User] = [
    josh,
    User(id: UserId(), emailAddress: "bjones@test.com", firstName: "Barry", lastName: "Jones"),
    maureen,
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
    josh.id: [
        usersDB[1].id,
        maureen.id
    ],
    maureen.id: [
        josh.id
    ]
]

var merlot = WineVariety(name: "Merlot")
var prosecco = WineVariety(name: "Prosecco")
var red = WineType(name: "Red", varieties: [merlot])
var bubbly = WineType(name: "Bubbly", varieties: [prosecco])
var winesDB: [UserId: [Wine]] = [
    josh.id: [
        Wine(type: bubbly, variety: prosecco, name: "Bubbletown", rating: 5),
        Wine(type: red, variety: merlot, name: "Wine 1", rating: 1),
        Wine(type: red, variety: merlot, name: "Wine 2", rating: 5)
    ],
    maureen.id: [
        Wine(type: red, variety: merlot, name: "Wine 1", rating: 1),
        Wine(type: red, variety: merlot, name: "Wine 2", rating: 5),
        Wine(type: red, variety: merlot, name: "Wine 3", rating: 3),
        Wine(type: red, variety: merlot, name: "Wine 4", rating: 4),
        Wine(type: red, variety: merlot, name: "Wine 5", rating: 5),
        Wine(type: bubbly, variety: prosecco, name: "Bubbletown", rating: 5)
    ]
]

func randomDelay(action: @escaping () -> ()) {
//    let wait = Double(arc4random_uniform(4) + 1)
//    delay(seconds: wait, action: action)
    action()
}

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

        if Container.shared.session.currentUserId == userId {
            for i in 0..<friends.count {
                friends[i].isFriend = true
            }
        }

        randomDelay {
            completion(.success(friends))
        }
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

        if let currentUserId = Container.shared.session.currentUserId {
            for i in 0..<matches.count {
                matches[i].isFriend = friendsDB[currentUserId]?.contains(matches[i].id) ?? false
            }
        }

        randomDelay {
            completion(.success(matches))
        }
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        if friendsDB[owningUserId] == nil {
            friendsDB[owningUserId] = []
        }
        friendsDB[owningUserId]!.append(friendId)
        var newFriend = usersDB.first(where: { $0.id == friendId })!
        if Container.shared.session.currentUserId == owningUserId {
            newFriend.isFriend = true
        }
        completion(.success(newFriend))
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        if let index = friendsDB[owningUserId]?.index(of: friendId) {
            friendsDB[owningUserId]?.remove(at: index)
        }        
        completion(.success)
    }
    
    func getUserById(_ id: UserId, completion: @escaping (Result<User?>) -> ()) {
        var user = usersDB.first(where: { $0.id == id })
        if user != nil, let currentUserId = Container.shared.session.currentUserId {
            user?.isFriend = friendsDB[currentUserId]?.contains(id) ?? false
        }
        completion(.success(user))
    }
}

class FakeRemoteWineDataStore: RemoteWineDataStore {
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        var wines = winesDB[userId] ?? []
        wines = wines.sorted(by: { $0.rating > $1.rating })
        wines = Array(wines.prefix(3))
        completion(.success(wines))
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine]>) -> ()) {
        var wines = winesDB[userId] ?? []
        wines = wines.filter { $0.type == wineType }
        completion(.success(wines))
    }
}