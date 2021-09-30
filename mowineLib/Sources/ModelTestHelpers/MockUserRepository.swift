//
//  MockUserRepository.swift
//  
//
//  Created by Josh Freed on 9/30/21.
//

import Foundation
import Model

class MockUserRepository: UserRepository {
    func getFriendsOfAndListenForUpdates(userId: UserId, completion: @escaping (Result<[User], Error>) -> ()) -> MoWineListenerRegistration {
        FakeRegistration()
    }

    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (Result<User?, Error>) -> ()) -> MoWineListenerRegistration {
        FakeRegistration()
    }

    func add(user: User) async throws {}

    func save(user: User) async throws {}

    var searchUsersResult: Result<[User], Error> = .success([])
    var searchUsers_searchString: String?
    var searchUsersWasCalled = false
    func searchUsers(searchString: String) async throws -> [User] {
        searchUsersWasCalled = true
        searchUsers_searchString = searchString
        switch searchUsersResult {
        case .success(let users): return users
        case.failure(let error): throw error
        }
    }

    var addFriendCalled = false
    var addFriend_owningUserId: UserId?
    var addFriend_friendId: UserId?
    var addFriendResult: Swift.Result<User, Error>?
    func addFriend(owningUserId: UserId, friendId: UserId) async throws -> User {
        addFriendCalled = true
        addFriend_owningUserId = owningUserId
        addFriend_friendId = friendId
        guard let result = addFriendResult else { fatalError() }
        switch result {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }

    func removeFriend(owningUserId: UserId, friendId: UserId) async throws {

    }

    var getUserByIdResult: Swift.Result<User?, Error>?
    var getUserByIdCalled = false
    var getUserById_id: UserId?
    func getUserById(_ id: UserId) async throws -> User? {
        getUserByIdCalled = true
        getUserById_id = id
        if let result = getUserByIdResult, case let .success(user) = result {
            return user
        }
        if let result = getUserByIdResult, case let .failure(error) = result {
            throw error
        }
        fatalError("Test not configured")
    }
}
