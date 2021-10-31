//
//  MockUserRepository.swift
//  
//
//  Created by Josh Freed on 9/30/21.
//

import Foundation
import MoWine_Domain
import XCTest
import Combine

class MockUserRepository: UserRepository {
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

    // MARK: - getFriends

    func getFriends(userId: UserId) -> AnyPublisher<[User], Error> {
        fatalError("Not implemented")
    }

    // MARK: - addFriend

    var addFriendCalled = false
    var addFriend_owningUserId: UserId?
    var addFriend_friendId: UserId?
    var addFriendError: Error?
    func addFriend(owningUserId: UserId, friendId: UserId) async throws {
        addFriendCalled = true
        addFriend_owningUserId = owningUserId
        addFriend_friendId = friendId
        if let error = addFriendError {
            throw error
        }
    }

    func verify_addFriend_wasCalled(owningUserId: UserId, friendUserId: UserId, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(addFriendCalled, file: file, line: line)
        XCTAssertEqual(owningUserId, addFriend_owningUserId, file: file, line: line)
        XCTAssertEqual(friendUserId, addFriend_friendId, file: file, line: line)
    }

    // MARK: - removeFriend

    private var removeFriendWasCalled = false
    var removeFriend_owningUserId: UserId?
    var removeFriend_friendId: UserId?
    var removeFriend_error: Error?

    func removeFriend(owningUserId: UserId, friendId: UserId) async throws {
        removeFriendWasCalled = true
        removeFriend_owningUserId = owningUserId
        removeFriend_friendId = friendId
        if let error = removeFriend_error {
            throw error
        }
    }

    func verify_removeFriend_wasCalled(owningUserId: UserId, friendUserId: UserId, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(removeFriendWasCalled, file: file, line: line)
        XCTAssertEqual(owningUserId, removeFriend_owningUserId, file: file, line: line)
        XCTAssertEqual(friendUserId, removeFriend_friendId, file: file, line: line)
    }

    // MARK: - getUserById

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
