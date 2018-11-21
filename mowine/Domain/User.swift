//
//  User.swift
//  mowine
//
//  Created by Josh Freed on 3/1/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import CoreData
import SwiftyBeaver

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

// MARK: CoreDataConvertible

extension User: CoreDataConvertible {
    static func toEntity(managedObject: ManagedUser) -> User? {
        guard let userIdStr = managedObject.userId else {
            return nil
        }
        
        let userId = UserId(string: userIdStr)
        var user = User(id: userId, emailAddress: managedObject.emailAddress ?? "")
        user.firstName = managedObject.firstName
        user.lastName = managedObject.lastName
        
        if let set = managedObject.friends, let array = Array(set) as? [ManagedFriend] {
            user.friends = array.compactMap {
                guard let managedFriend = $0.friend, let friendIdStr = managedFriend.userId else {
                    return nil
                }
                return Friendship(userId: user.id, friendId: UserId(string: friendIdStr))
            }
        }
        
        return user
    }

    func mapToManagedObject(_ managedObject: ManagedUser, mappingContext: CoreDataMappingContext) throws {
        managedObject.userId = id.asString
        managedObject.emailAddress = emailAddress
        managedObject.firstName = firstName
        managedObject.lastName = lastName
        managedObject.friends = try mappingContext.syncSet(friends)
        
        if managedObject.hasPersistentChangedValues {
            SwiftyBeaver.verbose("User::After::Object has persistent changes")
            SwiftyBeaver.verbose(managedObject.changedValues())
        }
    }
    
    func getIdPredicate() -> NSPredicate {
        return NSPredicate(format: "userId == %@", id.asString)
    }
}
