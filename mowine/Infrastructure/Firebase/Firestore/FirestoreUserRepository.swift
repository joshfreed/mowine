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

class FirestoreUserRepository: UserRepository {
    let db = Firestore.firestore()
        
    func add(user: User, completion: @escaping (Result<User, Error>) -> ()) {
        let data = user.toFirestore()
        
        db.collection("users").document(user.id.asString).setData(data) { err in
            if let err = err {
                SwiftyBeaver.error("Error adding document: \(err)")
                completion(.failure(err))
            } else {
                completion(.success(user))
            }
        }
    }
    
    func save(user: User, completion: @escaping (Result<User, Error>) -> ()) {
        let data = user.toFirestore()
        db.collection("users").document(user.id.asString).setData(data, merge: true)
        completion(.success(user))
    }
    
    func getUserById(_ id: UserId, completion: @escaping (Result<User?, Error>) -> ()) {
        let query = db.collection("users").document(id.asString)

        query.getDocument { (document, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists else {
                SwiftyBeaver.warning("Document does not exist")
                completion(.success(nil))
                return
            }

            guard let user = User.fromFirestore(document) else {
                SwiftyBeaver.warning("Couldn't build user from document")
                completion(.success(nil))
                return
            }

            completion(.success(user))
        }
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
    
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User], Error>) -> ()) {
        let query = db.collection("friends").whereField("userId", isEqualTo: userId.asString)
        
        query.getDocuments { (querySnapshot, error) in
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

    func searchUsers(searchString: String, completion: @escaping (Result<[User], Error>) -> ()) {
        let query = db.collection("users")
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                completion(.failure(error))
                return
            }
            
            if let documents = querySnapshot?.documents {
                let users = documents.compactMap { User.fromFirestore($0) }
                let matches = self.filterUsers(searchString: searchString, allUsers: users)
                completion(.success(matches))
            } else {
                completion(.success([]))
            }
        }
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
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User, Error>) -> ()) {
        let docId = "\(owningUserId)_\(friendId)"
        db.collection("friends").document(docId).setData([
            "userId": owningUserId.asString,
            "friendId": friendId.asString
        ]) { err in
            if let err = err {
                SwiftyBeaver.error("Error writing document: \(err)")
                completion(.failure(err))
            } else {
                self.getUserFromCache(userId: friendId, completion: completion)
            }
        }
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<Void, Error>) -> ()) {
        let docId = "\(owningUserId)_\(friendId)"
        db.collection("friends").document(docId).delete() { err in
            if let err = err {
                SwiftyBeaver.error("Error writing document: \(err)")
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }

    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool, Error>) -> ()) {
        let docId = "\(userId)_\(otherUserId)"
        db.collection("friends").document(docId).getDocument { (document, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }
    }
    
    //
    // Privates
    //
    
    private func getUserFromCache(userId: UserId, completion: @escaping (Result<User, Error>) -> ()) {
        let query = db.collection("users").document(userId.asString)
        query.getDocument(source: .cache) { (document, error) in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists, let user = User.fromFirestore(document) {
                completion(.success(user))
            } else {
                completion(.failure(UserRepositoryError.userNotFound))
            }
        }
    }
}
