//
//  FirestoreUserRepository.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import OSLog
import MoWine_Application
import MoWine_Domain

private let logger = Logger(category: .firebase)

public class FirestoreUserRepository: UserRepository {
    let db = Firestore.firestore()

    public init() {}

    public func add(user: User) async throws {
        try await db
            .collection("users")
            .document(user.id.asString)
            .setData(user.toFirestore())
    }
    
    public func save(user: User) async throws {
        let data = user.toFirestore()
        try await db.collection("users").document(user.id.asString).setData(data, merge: true)
    }

    public func getUserById(_ id: UserId) async throws -> User? {
        let query = db.collection("users").document(id.asString)

        let document = try await query.getDocument()

        guard document.exists else {
            logger.warning("Document does not exist")
            return nil
        }

        guard let user = User.fromFirestore(document) else {
            logger.warning("Couldn't build user from document")
            return nil
        }

        return user
    }

    public func getUserById(_ id: UserId) -> AnyPublisher<User?, Error> {
        let query = db
            .collection("users")
            .document(id.asString)

        return query
            .snapshotPublisher()
            .map { User.fromFirestore($0) }
            .eraseToAnyPublisher()
    }
    
    public func searchUsers(searchString: String) async throws -> [User] {
        let documents = try await db.collection("users").getDocuments().documents
        let users = documents.compactMap { User.fromFirestore($0) }
        return filterUsers(searchString: searchString, allUsers: users)
    }
    
    private func filterUsers(searchString: String, allUsers: [User]) -> [User] {
        let words = searchString.lowercased().split(separator: " ")
        var matches: [User] = []
        
        for word in words {
            let m = allUsers.filter {
                $0.fullName
                    .lowercased()
                    .split(separator: " ")
                    .contains { name in name.starts(with: word) }
            }
            matches.append(contentsOf: m)
        }
        
        return Array(Set(matches))
    }

    public func getFriends(userId: UserId) -> AnyPublisher<[User], Error> {
        let query = db
            .collection("friends")
            .whereField("userId", isEqualTo: userId.asString)

        func extractFriendId(_ document: QueryDocumentSnapshot) -> UserId? {
            let data = document.data()
            guard let friendIdStr = data["friendId"] as? String else { return nil }
            return UserId(string: friendIdStr)
        }

        return query
            .snapshotPublisher()
            .map { snapshot in snapshot.documents }
            .map { documents in documents.compactMap { extractFriendId($0) } }
            .asyncMap { [weak self] userIds in
                guard let self = self else { return [] }
                return try await self.getUsers(by: userIds)
            }
            .eraseToAnyPublisher()
    }

    private func getUsers(by ids: [UserId]) async throws -> [User] {
        guard ids.count > 0 else {
            return []
        }

        var users: [User] = []

        try await withThrowingTaskGroup(of: DocumentSnapshot.self) { group in
            for userId in ids {
                group.addTask {
                    let query = self.db.collection("users").document(userId.asString)
                    return try await query.getDocument()
                }
            }

            for try await document in group {
                if document.exists, let user = User.fromFirestore(document) {
                    users.append(user)
                }
            }
        }

        return users
    }
    
    public func addFriend(owningUserId: UserId, friendId: UserId) async throws {
        let docId = "\(owningUserId)_\(friendId)"

        try await db.collection("friends").document(docId).setData([
            "userId": owningUserId.asString,
            "friendId": friendId.asString
        ])
    }
    
    public func removeFriend(owningUserId: UserId, friendId: UserId) async throws {
        let docId = "\(owningUserId)_\(friendId)"
        try await db.collection("friends").document(docId).delete()
    }
    
    //
    // Privates
    //
    
    private func getUserFromCache(userId: UserId) async throws -> User {
        let query = db.collection("users").document(userId.asString)
        do {
            let document = try await query.getDocument(source: .cache)
            if document.exists, let user = User.fromFirestore(document) {
                return user
            } else {
                throw UserRepositoryError.userNotFound
            }
        }
    }
}
