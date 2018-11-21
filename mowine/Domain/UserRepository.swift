//
//  UserRepository.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

protocol UserRepository {
    func add(user: User, completion: @escaping (Result<User>) -> ())
    func save(user: User, completion: @escaping (Result<User>) -> ())
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ())
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ())
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ())
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ())
    func getUserById(_ id: UserId, completion: @escaping (Result<User?>) -> ())
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool>) -> ())
}

enum UserRepositoryError: Error {
    case userNotFound
}
