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
    let wait = Int(arc4random_uniform(4) + 1)
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(wait)) {
        action()
    }
//    action()
}

extension User {
    static func make(emailAddress: String, firstName: String, lastName: String) -> User {
        var user = User(id: UserId(), emailAddress: emailAddress)
        user.fullName = firstName + " " + lastName
        return user
    }
}

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
    
    func notLoggedIn() {
        _isLoggedIn = false
    }
    
    func loggedIn() {
        _isLoggedIn = true
    }
    
    func setUser(user: User) {
        _currentUser = user
        loggedIn()
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
    func signIn(emailAddress: String, password: String) async throws {
        if let user = usersDB.first(where: { $0.emailAddress == emailAddress }) {
            (JFContainer.shared.session as? FakeSession)?.setUser(user: user)
        } else {
            throw EmailAuthenticationErrors.userNotFound
        }
    }    
    
    func signUp(emailAddress: String, password: String) async throws {
        let user = User(id: UserId(), emailAddress: emailAddress)
        (JFContainer.shared.session as? FakeSession)?.setUser(user: user)
        usersDB.append(user)
    }
}

class FakeUserRepository: UserRepository {
    func setUsers(_ users: [User]) {
        usersDB = users
    }
    
    func getById(_ id: UserId) -> User? {
        usersDB.first(where: { $0.id == id })        
    }
    
    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (Swift.Result<User?, Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
    
    func add(user: User) async throws {
        usersDB.append(user)
    }
    
    func save(user: User) async throws {
        if let index = usersDB.firstIndex(where: { $0.emailAddress == user.emailAddress }) {
            usersDB[index] = user
        }
    }

    func getFriendsOf(userId: UserId, completion: @escaping (Swift.Result<[User], Error>) -> ()) {
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
    
    func searchUsers(searchString: String, completion: @escaping (Swift.Result<[User], Error>) -> ()) {
        let words = searchString.split(separator: " ")
        var matches: [User] = []
        
        for word in words {
            let m = usersDB.filter {
                $0.fullName.lowercased().starts(with: word)
            }
            matches.append(contentsOf: m)
        }

        randomDelay {
            completion(.success(matches))
        }
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Swift.Result<User, Error>) -> ()) {
        if friendsDB[owningUserId] == nil {
            friendsDB[owningUserId] = []
        }
        friendsDB[owningUserId]!.append(friendId)
        let newFriend = usersDB.first(where: { $0.id == friendId })!
        completion(.success(newFriend))
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        if let index = friendsDB[owningUserId]?.firstIndex(of: friendId) {
            friendsDB[owningUserId]?.remove(at: index)
        }        
        completion(.success(()))
    }
    
    func getUserById(_ id: UserId) async throws -> User? {
        usersDB.first(where: { $0.id == id })
    }

    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Swift.Result<Bool, Error>) -> ()) {
        
    }
    
    func getFriendsOfAndListenForUpdates(userId: UserId, completion: @escaping (Swift.Result<[User], Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
}

class FakeDataReadService: DataReadService {
    func getData(url: String, completion: @escaping (Swift.Result<Data?, Error>) -> ()) {
    }
}


class FakeDataWriteService: DataWriteService {
    func putData(_ data: Data, url: String, completion: @escaping (Swift.Result<URL, Error>) -> ()) {
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

class FakeWineWorker: WineWorker {
    init() {
        super.init(
            wineRepository: MemoryWineRepository(),
            imageWorker: FakeWineImageWorker(),
            session: FakeSession()
        )
    }
}

class FakeWineImageWorker: WineImageWorkerProtocol {
    func createImages(wineId: WineId, photo: WineImage?) -> Data? {
        nil
    }
    
    func fetchPhoto(wineId: WineId, completion: @escaping (Swift.Result<Data?, Error>) -> ()) {
        
    }
    
    func fetchPhoto(wine: Wine, completion: @escaping (Swift.Result<Data?, Error>) -> ()) {
        
    }
}

class FakeUsersService: UsersService {
    init() {
        super.init(session: FakeSession(), userRepository: FakeUserRepository())
    }
}
