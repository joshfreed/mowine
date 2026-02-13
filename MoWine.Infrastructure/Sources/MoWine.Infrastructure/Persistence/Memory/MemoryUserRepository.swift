//
//  MemoryUserRepository.swift
//  mowine
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Application
import MoWine_Domain

public class MemoryUserRepository: UserRepository {
    var users: [User] = []

    public init() {}

    public func add(user: User) async throws {
        guard !users.contains(where: { $0.id == user.id }) else { return }
        users.append(user)
    }

    func addUserSync(_ user: User) {
        guard !users.contains(where: { $0.id == user.id }) else { return }
        users.append(user)
    }

    public func save(user: User) async throws {
        guard let index = users.firstIndex(where: { $0.id == user.id }) else { return }
        users[index] = user
    }

    public func searchUsers(searchString: String) async throws -> [User] {
        let words = searchString.split(separator: " ")
        var matches: [User] = []

        for word in words {
            let m = users.filter {
                $0.fullName.lowercased().starts(with: word)
            }
            matches.append(contentsOf: m)
        }

        return matches
    }

    public func getFriends(userId: UserId) -> AnyPublisher<[User], Error> {
        fatalError("Not implemented")
    }

    public func addFriend(owningUserId: UserId, friendId: UserId) async throws {}

    public func removeFriend(owningUserId: UserId, friendId: UserId) async throws {}

    public func getUserById(_ id: UserId) async throws -> User? {
        users.first { $0.id == id }
    }

    public func getUserById(_ id: UserId) -> AnyPublisher<User?, Error> {
        fatalError("Not implemented")
    }
}
