//
//  FirestoreUserRepository.swift
//  mowine
//
//  Created by Josh Freed on 12/8/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import FirebaseFirestore
import SwiftyBeaver

class FirestoreUserRepository: UserRepository {
    let db = Firestore.firestore()
    
    init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
//        db.disableNetwork(completion: nil)
    }
    
    func add(user: User, completion: @escaping (Result<User>) -> ()) {
        let data: [String: Any?] = [
            "userId": user.id.asString,
            "email": user.emailAddress,
            "firstName": user.firstName,
            "lastName": user.lastName,
        ]
        
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: data) { err in
            if let err = err {
                SwiftyBeaver.error("Error adding document: \(err)")
                completion(.failure(err))
            } else {
                print("Document added with ID: \(ref!.documentID)")
                completion(.success(user))
            }
        }
    }
    
    func save(user: User, completion: @escaping (Result<User>) -> ()) {
        
    }
    
    func getUserById(_ id: UserId, completion: @escaping (Result<User?>) -> ()) {
        let query = db.collection("users").whereField("userId", isEqualTo: id.asString)
        
        query.getDocuments(source: .cache) { (querySnapshot, err) in
            if let err = err {
                SwiftyBeaver.error("\(err)")
                completion(.failure(err))
            } else {
                do {
                    let user = try self.makeUser(from: querySnapshot?.documents.first)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                SwiftyBeaver.error("\(err)")
                completion(.failure(err))
            } else {
                do {
                    let user = try self.makeUser(from: querySnapshot?.documents.first)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func makeUser(from doc: QueryDocumentSnapshot?) throws -> User? {
        guard let doc = doc else { return nil }
        let dataDict = doc.data()
        let user = try User.toUser(from: dataDict)
        return user
    }
    
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        completion(.success([]))
    }
    
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        completion(.success([]))
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        
    }

    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool>) -> ()) {
        completion(.success(false))
    }
}
