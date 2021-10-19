//
//  FirestoreUserRepository.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseFirestore
import SwiftyBeaver
import Model
import MoWine_Domain

class FirestoreUserRepository: UserRepository {
    let db = Firestore.firestore()

    func add(user: User) async throws {
        try await db
            .collection("users")
            .document(user.id.asString)
            .setData(user.toFirestore())
    }
    
    func save(user: User, completion: @escaping (Result<User, Error>) -> ()) {
        let data = user.toFirestore()
        db.collection("users").document(user.id.asString).setData(data, merge: true)
        completion(.success(user))
    }

    func save(user: User) async throws {
        let data = user.toFirestore()
        try await db.collection("users").document(user.id.asString).setData(data, merge: true)
    }

    func getUserById(_ id: UserId) async throws -> User? {
        let query = db.collection("users").document(id.asString)

        let document = try await query.getDocument()

        guard document.exists else {
            SwiftyBeaver.warning("Document does not exist")
            return nil
        }

        guard let user = User.fromFirestore(document) else {
            SwiftyBeaver.warning("Couldn't build user from document")
            return nil
        }

        return user
    }

    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (Result<User?, Error>) -> ()) -> MoWineListenerRegistration {
        let listener = db.collection("users").document(id.asString).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                completion(.failure(error))
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                SwiftyBeaver.warning("Document does not exist")
                completion(.success(nil))
                return
            }
            
            guard let data = document.data() else {
                SwiftyBeaver.warning("Document was empty")
                completion(.success(nil))
                return
            }
            
            SwiftyBeaver.debug("Received user document snapshot w/ data: \(data)")
            
            guard let user = User.fromFirestore(document) else {
                SwiftyBeaver.warning("Couldn't build user from document")
                completion(.success(nil))
                return
            }
            
            completion(.success(user))
        }
        
        return MyFirebaseListenerRegistration(wrapped: listener)
    }
    
    func getFriendsOfAndListenForUpdates(userId: UserId, completion: @escaping (Result<[User], Error>) -> ()) -> MoWineListenerRegistration {
        let query = db.collection("friends").whereField("userId", isEqualTo: userId.asString)
        
        let listener = query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                completion(.failure(error))
            } else {
                if let documents = querySnapshot?.documents {
                    let friendIds: [UserId] = documents.compactMap {
                        let data = $0.data()
                        guard let friendIdStr = data["friendId"] as? String else { return nil }
                        return UserId(string: friendIdStr)
                    }
                    self.getUsers(by: friendIds, completion: completion)
                } else {
                    completion(.success([]))
                }
            }
        }
        
        return MyFirebaseListenerRegistration(wrapped: listener)
    }

    private func getUsers(by ids: [UserId], completion: @escaping (Result<[User], Error>) -> ()) {
        guard ids.count > 0 else {
            completion(.success([]))
            return
        }
        
        let group = DispatchGroup()
        var friends: [User] = []
        for userId in ids {
            group.enter()
            let query = db.collection("users").document(userId.asString)
            query.getDocument { (document, error) in
                if let error = error {
                    SwiftyBeaver.error("\(error)")
                    completion(.failure(error))
                    return
                }
                
                if let document = document, document.exists, let friend = User.fromFirestore(document) {
                    friends.append(friend)
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(.success(friends))
        }
    }

    func searchUsers(searchString: String) async throws -> [User] {
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
    
    func addFriend(owningUserId: UserId, friendId: UserId) async throws -> User {
        let docId = "\(owningUserId)_\(friendId)"

        try await db.collection("friends").document(docId).setData([
            "userId": owningUserId.asString,
            "friendId": friendId.asString
        ])

        return try await getUserFromCache(userId: friendId)
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId) async throws {
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
