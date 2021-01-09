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
    var fullName: String = ""
    var profilePictureUrl: URL?
    var friends: [Friendship] = []
    
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
        if let index = friends.firstIndex(of: friend) {
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
        
        if let fullName = dataDict["fullName"] as? String {
            user.fullName = fullName
        } else {
            user.fullName = fullName(dataDict)
        }
        
        if let photoUrlString = dataDict["photoURL"] as? String {
            user.profilePictureUrl = URL(string: photoUrlString)
        }
        return user
    }
    
    private static func fullName(_ dataDict: [String: Any]) -> String {
        let firstName = (dataDict["firstName"] as? String) ?? ""
        let lastName = (dataDict["lastName"] as? String) ?? ""
        
        var _fullName = firstName
        if !_fullName.isEmpty {
            _fullName += " "
        }
        _fullName += lastName
        return _fullName
    }
    
    func toFirestore() -> [String: Any] {
        var data: [String: Any] = [
            "email": emailAddress,
            "fullName": fullName
        ]
                
        if let photoURL = profilePictureUrl {
            data["photoURL"] = photoURL.absoluteString
        }
        
        return data
    }
}
