//
//  Fakes.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import PromiseKit

var josh = User.make(emailAddress: "josh@jpfreed.com", firstName: "Josh", lastName: "Freed")
var maureen = User.make(emailAddress: "mshockley13@gmail.com", firstName: "Maureen", lastName: "Shockley")

var usersDB: [User] = [
    josh,
    User.make(emailAddress: "bjones@test.com", firstName: "Barry", lastName: "Jones"),
    maureen,
    User.make(emailAddress: "mbananas@gmail.com", firstName: "Maurice", lastName: "Bananas"),
    User.make(emailAddress: "test1@test.com", firstName: "Test", lastName: "User1"),
    User.make(emailAddress: "test2@test.com", firstName: "Test", lastName: "User2"),
    User.make(emailAddress: "test3@test.com", firstName: "Test", lastName: "User3"),
    User.make(emailAddress: "test4@test.com", firstName: "Test", lastName: "User4"),
    User.make(emailAddress: "test5@test.com", firstName: "Test", lastName: "User5"),
    User.make(emailAddress: "test6@test.com", firstName: "Test", lastName: "User6"),
    User.make(emailAddress: "test7@test.com", firstName: "Test", lastName: "User7"),
    User.make(emailAddress: "test8@test.com", firstName: "Test", lastName: "User8"),
    User.make(emailAddress: "test9@test.com", firstName: "Test", lastName: "User9"),
    User.make(emailAddress: "test10@test.com", firstName: "Test", lastName: "User10"),
    User.make(emailAddress: "test11@test.com", firstName: "Test", lastName: "User12"),
    User.make(emailAddress: "test12@test.com", firstName: "Test", lastName: "User13"),
    User.make(emailAddress: "test13@test.com", firstName: "Test", lastName: "User14"),
    User.make(emailAddress: "test14@test.com", firstName: "Test", lastName: "User15"),
    User.make(emailAddress: "test15@test.com", firstName: "Test", lastName: "User16"),
    User.make(emailAddress: "test16@test.com", firstName: "Test", lastName: "User17"),
    User.make(emailAddress: "test17@test.com", firstName: "Test", lastName: "User18"),
    User.make(emailAddress: "test18@test.com", firstName: "Test", lastName: "User19"),
    User.make(emailAddress: "test19@test.com", firstName: "Test", lastName: "User19"),
    User.make(emailAddress: "test20@test.com", firstName: "Test", lastName: "User20"),
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
        Wine(userId: josh.id, type: bubbly, variety: prosecco, name: "Bubbletown", rating: 5),
        Wine(userId: josh.id, type: red, variety: merlot, name: "Wine 1", rating: 1),
        Wine(userId: josh.id, type: red, variety: merlot, name: "Wine 2", rating: 5)
    ],
    maureen.id: [
        Wine(userId: maureen.id, type: red, variety: merlot, name: "Wine 1", rating: 1),
        Wine(userId: maureen.id, type: red, variety: merlot, name: "Wine 2", rating: 5),
        Wine(userId: maureen.id, type: red, variety: merlot, name: "Wine 3", rating: 3),
        Wine(userId: maureen.id, type: red, variety: merlot, name: "Wine 4", rating: 4),
        Wine(userId: maureen.id, type: red, variety: merlot, name: "Wine 5", rating: 5),
        Wine(userId: maureen.id, type: bubbly, variety: prosecco, name: "Bubbletown", rating: 5)
    ]
]

func randomDelay(action: @escaping () -> ()) {
    let wait = Double(arc4random_uniform(4) + 1)
    delay(seconds: wait, action: action)
//    action()
}

extension User {
    static func make(emailAddress: String, firstName: String, lastName: String) -> User {
        var user = User(emailAddress: emailAddress)
        user.firstName = firstName
        user.lastName = lastName
        return user
    }
}

class FakeSession: Session {
    private var _isLoggedIn = false
    private var _photoUrl: URL?
    
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
    
    func resume(completion: @escaping (EmptyResult) -> ()) {
        _isLoggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        if let emailAddress = UserDefaults.standard.value(forKey: "emailAddress") as? String {
            _currentUser = usersDB.first(where: { $0.emailAddress == emailAddress })
        } else {
            UserDefaults.standard.set(false, forKey: "loggedIn")
            _isLoggedIn = false
        }
        completion(.success)
    }
    
    func end() {
        _isLoggedIn = false
        _currentUser = nil
        UserDefaults.standard.removeObject(forKey: "emailAddress")
        UserDefaults.standard.removeObject(forKey: "loggedIn")
    }

    func getCurrentAuth() -> MoWineAuth? {
        return FakeMoWineAuth(email: "boobs@butts.com")
    }

    func reauthenticate(withEmail email: String, password: String, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        completion(.success(()))
//        completion(.failure(MoWineError.error(message: "Just a test error")))
    }

    func setPhotoUrl(_ url: URL, completion: @escaping (EmptyResult) -> ()) {
        _photoUrl = url
        completion(.success)
    }

    func getPhotoUrl() -> URL? {
        return _photoUrl
    }
    
    func updateEmailAddress(_ emailAddress: String) -> Promise<Void> {
//        return Promise(error: SessionError.requiresRecentLogin)
        return Promise()
    }
}

struct FakeMoWineAuth: MoWineAuth {
    var email: String?
}

class FakeEmailAuth: EmailAuthenticationService {
    func signIn(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        if let user = usersDB.first(where: { $0.emailAddress == emailAddress }) {
            (JFContainer.shared.session as? FakeSession)?.setUser(user: user)
            completion(.success)
        } else {
            completion(.failure(EmailAuthenticationErrors.userNotFound))
        }
    }
    
    func signUp(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        let user = User(emailAddress: emailAddress)
        (JFContainer.shared.session as? FakeSession)?.setUser(user: user)
        usersDB.append(user)
        completion(.success)
    }
}

class FakeUserRepository: UserRepository {
    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (JFLib.Result<User?>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
    
    func add(user: User, completion: @escaping (JFLib.Result<User>) -> ()) {
        usersDB.append(user)
        completion(.success(user))
    }
    
    func save(user: User, completion: @escaping (JFLib.Result<User>) -> ()) {
        if let index = usersDB.firstIndex(where: { $0.emailAddress == user.emailAddress }) {
            usersDB[index] = user
        }
        completion(.success(user))
    }

    func getFriendsOf(userId: UserId, completion: @escaping (JFLib.Result<[User]>) -> ()) {
        let friendIds = friendsDB[userId] ?? []
        var friends: [User] = []
        for friendId in friendIds {
            if let friend = usersDB.first(where: { $0.id == friendId }) {
                friends.append(friend)
            }
        }

        randomDelay {
            completion(.success(friends))
        }
    }
    
    func searchUsers(searchString: String, completion: @escaping (JFLib.Result<[User]>) -> ()) {
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

        randomDelay {
            completion(.success(matches))
        }
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (JFLib.Result<User>) -> ()) {
        if friendsDB[owningUserId] == nil {
            friendsDB[owningUserId] = []
        }
        friendsDB[owningUserId]!.append(friendId)
        let newFriend = usersDB.first(where: { $0.id == friendId })!
        completion(.success(newFriend))
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        if let index = friendsDB[owningUserId]?.firstIndex(of: friendId) {
            friendsDB[owningUserId]?.remove(at: index)
        }        
        completion(.success)
    }
    
    func getUserById(_ id: UserId, completion: @escaping (JFLib.Result<User?>) -> ()) {
        let user = usersDB.first(where: { $0.id == id })
        completion(.success(user))
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (JFLib.Result<Bool>) -> ()) {
        
    }
}

/*
class FakeRemoteWineDataStore: RemoteWineDataStore {
    init() {
        winesDB[maureen.id]?[1].location = "This is a long string that is a long string that should wrap around and go to the next liiiiiiine?"
    }
    
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
*/
