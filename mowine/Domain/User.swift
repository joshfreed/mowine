//
//  User.swift
//  mowine
//
//  Created by Josh Freed on 3/1/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import CoreData

typealias UserId = StringIdentity

struct User: Equatable {
    let id: UserId
    var emailAddress: String
    var firstName: String?
    var lastName: String?
    var profilePicture: UIImage?
    private(set) var friends: [Friend] = []
    private(set) var syncState: SyncStatus = .synced
    var updatedAt: Date
    
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
        updatedAt = Date()
    }
    
    init(id: UserId, emailAddress: String) {
        self.id = id
        self.emailAddress = emailAddress
        updatedAt = Date()
    }

    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.emailAddress == rhs.emailAddress
    }
    
    mutating func addFriend(user: User) {
        let friend = Friend(user: self, friend: user)
        
        if friends.contains(friend) {
            return
        }
        
        friends.append(friend)
    }
    
    mutating func removeFriend(user: User) {
        let friend = Friend(user: self, friend: user)
        if let index = friends.index(of: friend) {
            friends.remove(at: index)
        }
    }
    
    func isFriendsWith(_ user: User) -> Bool {
        let friend = Friend(user: self, friend: user)
        return friends.contains(friend)
    }
}

extension User: Syncable {
    var identifier: String {
        return id.asString
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
        user.syncState = SyncStatus(rawValue: Int(managedObject.syncState)) ?? .synced
        
        if let set = managedObject.friends, let array = Array(set) as? [ManagedFriend] {
            user.friends = array.compactMap {
                guard let managedFriend = $0.friend else { return nil }
                guard let friend = User.toEntity(managedObject: managedFriend) else { return nil }
                return Friend(user: user, friend: friend)
            }
        }
        
        return user
    }
    
    func mapToManagedObject(_ managedObject: ManagedUser, mappingContext: CoreDataMappingContext) throws {
        managedObject.userId = id.asString
        managedObject.emailAddress = emailAddress
        managedObject.firstName = firstName
        managedObject.lastName = lastName
        managedObject.syncState = Int16(syncState.rawValue)
        managedObject.updatedAt = updatedAt
        managedObject.friends = try mappingContext.syncSet(friends)
    }
    
    func getIdPredicate() -> NSPredicate {
        return NSPredicate(format: "userId == %@", id.asString)
    }
}

extension User: DynamoConvertible {
    static func toEntity(awsObject: AWSUser) -> User? {
        guard let userIdStr = awsObject._userId else {
            return nil
        }
        guard let emailAddress = awsObject._email else {
            return nil
        }
        let userId = UserId(string: userIdStr)
        var user = User(id: userId, emailAddress: emailAddress)
        user.firstName = awsObject._firstName
        user.lastName = awsObject._lastName
        user.updatedAt = ISO8601DateFormatter().date(from: awsObject._updatedAt ?? "") ?? Date()
        user.syncState = .synced
        return user
    }
    
    func toDynamoDb() -> AWSUser? {
        let awsUser: AWSUser = AWSUser()
        awsUser._userId = id.description
        awsUser._email = emailAddress
        awsUser._firstName = firstName
        awsUser._lastName = lastName
        awsUser._updatedAt = ISO8601DateFormatter().string(from: updatedAt)
        return awsUser
    }
}
