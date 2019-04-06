//
//  User.swift
//  mowine
//
//  Created by Josh Freed on 3/1/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver
import FirebaseFirestore

typealias UserId = StringIdentity

struct User: Equatable {
    let id: UserId
    var emailAddress: String
    var firstName: String?
    var lastName: String?
    var profilePicture: UIImage?
    var friends: [Friendship] = []
    
    var fullName: String {
        let firstName = self.firstName ?? ""
        let lastName = self.lastName ?? ""
        
        var _fullName = firstName
        if !_fullName.isEmpty {
            _fullName += " "
        }
        _fullName += lastName
        return _fullName
    }
    
    init(emailAddress: String) {
        self.id = UserId()
        self.emailAddress = emailAddress
    }
    
    init(id: UserId, emailAddress: String) {
        self.id = id
        self.emailAddress = emailAddress
    }

    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.emailAddress == rhs.emailAddress
    }
    
    mutating func addFriend(user: User) {
        let friend = Friendship(userId: id, friendId: user.id)
        
        if friends.contains(friend) {
            return
        }
        
        friends.append(friend)
    }
    
    mutating func addFriend(_ friendId: UserId) {
        let friend = Friendship(userId: id, friendId: friendId)
        
        if friends.contains(friend) {
            return
        }
        
        friends.append(friend)
    }
    
    mutating func removeFriend(user: User) {
        let friend = Friendship(userId: id, friendId: user.id)
        if let index = friends.index(of: friend) {
            friends.remove(at: index)
        }
    }
    
    func isFriendsWith(_ user: User) -> Bool {
        let friend = Friendship(userId: id, friendId: user.id)
        return friends.contains(friend)
    }
    
    func isFriendsWith(_ friendId: UserId) -> Bool {
        return friends.contains(where: { $0.friendId == friendId })
    }
}

// MARK: Dictionary

extension User {
    static func fromFirestore(_ document: DocumentSnapshot) -> User? {
        guard
            let dataDict = document.data(),
            let emailAddress = dataDict["email"] as? String
        else {
            return nil
        }
        let userId = UserId(string: document.documentID)
        var user = User(id: userId, emailAddress: emailAddress)
        user.firstName = dataDict["firstName"] as? String
        user.lastName = dataDict["lastName"] as? String
        return user
    }
    
    func toFirestore() -> [String: Any] {
        var data: [String: Any] = [
            "email": emailAddress
        ]
        if let firstName = firstName {
            data["firstName"] = firstName
        }
        if let lastName = lastName {
            data["lastName"] = lastName
        }
        return data
    }
}
