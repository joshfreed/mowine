//
//  Mocks.swift
//  mowineTests
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
@testable import mowine
import JFLib

class MockWineRepository: WineRepository {
    func getMyWines(completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        completion(.success(wine))
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        completion(.success)
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
}

class MockWineTypeRepository: WineTypeRepository {
    var types: [WineType] = []
    
    func getAll(completion: @escaping (Result<[WineType]>) -> ()) {
        completion(.success(types))
    }
    
    func getWineType(named name: String, completion: @escaping (Result<WineType?>) -> ()) {
        let type = types.first(where: { $0.name == name })
        completion(.success(type))        
    }
}

class MockUserRepository: UserRepository {
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool>) -> ()) {
        
    }
    
    func saveUser(user: User, completion: @escaping (Result<User>) -> ()) {
        
    }
    
    var getFriendsOfResult: Result<[User]>?
    var getFriendsOf_userId: UserId?
    var getFriendsOfWasCalled = false
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        getFriendsOfWasCalled = true
        getFriendsOf_userId = userId
        if let result = getFriendsOfResult {
            completion(result)
        }
    }
    
    var searchUsersResult: Result<[User]>?
    var searchUsers_searchString: String?
    var searchUsersWasCalled = false
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        searchUsersWasCalled = true
        searchUsers_searchString = searchString
        if let result = searchUsersResult {
            completion(result)
        }
    }
    
    var addFriendCalled = false
    var addFriend_owningUserId: UserId?
    var addFriend_friendId: UserId?
    var addFriendResult: Result<User>?
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        addFriendCalled = true
        addFriend_owningUserId = owningUserId
        addFriend_friendId = friendId
        if let result = addFriendResult {
            completion(result)
        }
    }

    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {

    }

    var getUserByIdResult: Result<User?>?
    var getUserByIdCalled = false
    var getUserById_id: UserId?
    func getUserById(_ id: UserId, completion: @escaping (Result<User?>) -> ()) {
        getUserByIdCalled = true
        getUserById_id = id
        if let result = getUserByIdResult {
            completion(result)
        }
    }
}

class MockSession: Session {
    private var _currentUser: User?
    
    var isLoggedIn: Bool {
        return _currentUser != nil
    }
    
    var _currentUserId: UserId?
    var currentUserId: UserId? {
        return _currentUserId ?? _currentUser?.id
    }
    
    func resume(completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func login(userId: UserId) {
        _currentUserId = userId
    }
    
    func login(user: User) {
        _currentUser = user
    }
    
    func getCurrentUser(completion: @escaping (Result<User?>) -> ()) {
        if let currentUser = _currentUser {
            completion(.success(currentUser))
        } else {
            // ??DF?DF?
        }
    }
    
    func end() {
        _currentUser = nil
    }
}

class MockEmailAuthService: EmailAuthenticationService {
    var signInCalled = false
    var signIn_emailAddress: String?
    var signIn_password: String?
    var signInResult: EmptyResult?
    func signIn(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        signInCalled = true
        signIn_emailAddress = emailAddress
        signIn_password = password
        if let result = signInResult {
            completion(result)
        }
    }
    
    var signUpCalled = false
    var signUp_emailAddress: String?
    var signUp_password: String?
    var signUpResult: EmptyResult?
    func signUp(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        signUpCalled = true
        signUp_emailAddress = emailAddress
        signUp_password = password
        if let result = signUpResult {
            completion(result)
        }
    }
}

