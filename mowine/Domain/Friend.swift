//
//  Friend.swift
//  mowine
//
//  Created by Josh Freed on 11/3/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

struct Friend: Equatable {
    let user: User
    let friend: User
    private(set) var syncState: SyncStatus
    var updatedAt: Date
    
    init(user: User, friend: User) {
        self.user = user
        self.friend = friend
        updatedAt = Date()
        syncState = .created
    }
    
    static func ==(lhs: Friend, rhs: Friend) -> Bool {
        return lhs.user.id == rhs.user.id && lhs.friend.id == rhs.friend.id
    }
}

// MARK: Syncable

extension Friend: Syncable {
    var identifier: String {
        return "\(user.id)::\(friend.id)"
    }
}


// MARK: CoreDataConvertible

extension Friend: CoreDataConvertible {
    static func toEntity(managedObject: ManagedFriend) -> Friend? {
        guard let managedUser = managedObject.user else { return nil }
        guard let managedFriend = managedObject.friend else { return nil }
        guard let user = User.toEntity(managedObject: managedUser) else { return nil }
        guard let friend = User.toEntity(managedObject: managedFriend) else { return nil }
        return Friend(user: user, friend: friend)
    }
    
    func mapToManagedObject(_ managedObject: ManagedFriend, mappingContext: CoreDataMappingContext) throws {
        managedObject.user = try mappingContext.syncOne(user)
        managedObject.friend = try mappingContext.syncOne(friend)
    }
    
    func getIdPredicate() -> NSPredicate {
        return NSPredicate(format: "user.userId == %@ && friend.userId == %@", user.id.asString, friend.id.asString)
    }
}

// MARK: - DynamoConvertible

extension Friend: DynamoConvertible {
    static func toEntity(awsObject: AWSFriend) -> Friend? {
        guard let userIdStr = awsObject._userId else { return nil }
        guard let friendIdStr = awsObject._friendId else { return nil }
        let user = User(id: UserId(string: userIdStr), emailAddress: "")
        let friend = User(id: UserId(string: friendIdStr), emailAddress: "")
        return Friend(user: user, friend: friend)
    }
    
    func toDynamoDb() -> AWSFriend? {
        let awsFriend: AWSFriend = AWSFriend()
        awsFriend._userId = user.id.asString
        awsFriend._friendId = friend.id.asString
        return awsFriend
    }
}
