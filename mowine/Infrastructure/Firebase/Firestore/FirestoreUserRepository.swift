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
    }
    
    func add(user: User, completion: @escaping (Result<User>) -> ()) {
        let data: [String: Any?] = [
            "userId": user.id.asString,
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
        db.collection("users").whereField("userId", isEqualTo: id.asString).getDocuments() { (querySnapshot, err) in
            if let err = err {
                SwiftyBeaver.error("Error adding document: \(err)")
                completion(.failure(err))
            } else {
                if let first = querySnapshot?.documents.first {
                    let dataDict = first.data()
                    let userIdStr = dataDict["userId"] as! String
                    let userId = UserId(string: userIdStr)
                    let user = User(id: userId, emailAddress: "")
                    completion(.success(user))
                } else {
                    completion(.success(nil))
                }
            }
        }
    }
    
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        
    }
    
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        
    }

    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool>) -> ()) {
        
    }
}
