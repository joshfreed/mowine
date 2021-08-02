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
    @available(*, deprecated, message: "Prefer async alternative instead")
    func add(user: User, completion: @escaping (Result<User, Error>) -> ())

    func add(user: User) async throws
    @available(*, deprecated, message: "Prefer async alternative instead")
    func save(user: User, completion: @escaping (Result<User, Error>) -> ())

    func save(user: User) async throws
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User], Error>) -> ())
    func searchUsers(searchString: String, completion: @escaping (Result<[User], Error>) -> ())
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User, Error>) -> ())
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<Void, Error>) -> ())
    @available(*, deprecated, message: "Prefer async alternative instead")
    func getUserById(_ id: UserId, completion: @escaping (Result<User?, Error>) -> ())

    func getUserById(_ id: UserId) async throws -> User?
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool, Error>) -> ())
    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (Result<User?, Error>) -> ()) -> MoWineListenerRegistration
    func getFriendsOfAndListenForUpdates(userId: UserId, completion: @escaping (Result<[User], Error>) -> ()) -> MoWineListenerRegistration
}

public enum UserRepositoryError: Error {
    case userNotFound
}
