//
//  MemoryUserRepository.swift
//  mowine
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Model
import MoWine_Domain

class MemoryUserRepository: UserRepository {
    var users: [User] = []

    func add(user: User) async throws {
        guard !users.contains(where: { $0.id == user.id }) else { return }
        users.append(user)
    }

    func addUserSync(_ user: User) {
        guard !users.contains(where: { $0.id == user.id }) else { return }
        users.append(user)
    }

    func save(user: User) async throws {
        guard let index = users.firstIndex(where: { $0.id == user.id }) else { return }
        users[index] = user
    }

    func searchUsers(searchString: String) async throws -> [User] {
        let words = searchString.split(separator: " ")
        var matches: [User] = []

        for word in words {
            let m = users.filter {
                $0.fullName.lowercased().starts(with: word)
            }
            matches.append(contentsOf: m)
        }

        return try await withCheckedThrowingContinuation { continuation in
            continuation.resume(with: .success(matches))
        }
    }

    func addFriend(owningUserId: UserId, friendId: UserId) async throws -> User {
        fatalError("Not implemented")
    }

    func removeFriend(owningUserId: UserId, friendId: UserId) async throws {

    }

    func getUserById(_ id: UserId) async throws -> User? {
        users.first { $0.id == id }
    }

    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (Result<User?, Error>) -> ()) -> MoWineListenerRegistration {
        fatalError("Not implemented")
    }

    func getFriendsOfAndListenForUpdates(userId: UserId, completion: @escaping (Result<[User], Error>) -> ()) -> MoWineListenerRegistration {
        fatalError("Not implemented")
    }
}
