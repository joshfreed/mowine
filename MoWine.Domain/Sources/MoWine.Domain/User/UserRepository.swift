//
//  UserRepository.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import Combine

public protocol UserRepository {
    // Users
    func add(user: User) async throws
    func save(user: User) async throws
    func searchUsers(searchString: String) async throws -> [User]
    func getUserById(_ id: UserId) async throws -> User?
    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (Result<User?, Error>) -> ()) -> MoWineListenerRegistration

    // Friends
    func getFriends(userId: UserId) -> AnyPublisher<[User], Error>
    func addFriend(owningUserId: UserId, friendId: UserId) async throws
    func removeFriend(owningUserId: UserId, friendId: UserId) async throws
}

public enum UserRepositoryError: Error {
    case userNotFound
}
