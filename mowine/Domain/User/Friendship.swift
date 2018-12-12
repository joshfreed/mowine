//
//  Friend.swift
//  mowine
//
//  Created by Josh Freed on 11/3/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

struct Friendship: Equatable {
    let id: String
    let userId: UserId
    let friendId: UserId
    
    init(id: String, userId: UserId, friendId: UserId) {
        self.id = id
        self.userId = userId
        self.friendId = friendId
    }
    
    init(userId: UserId, friendId: UserId) {
        id = UUID().uuidString
        self.userId = userId
        self.friendId = friendId
    }
    
    static func ==(lhs: Friendship, rhs: Friendship) -> Bool {
        return lhs.userId == rhs.userId && lhs.friendId == rhs.friendId
    }
}

// MARK: CoreDataConvertible

extension Friendship: CoreDataConvertible {
    static func toEntity(managedObject: ManagedFriend) -> Friendship? {
        guard let managedUser = managedObject.user else { return nil }
        guard let managedFriend = managedObject.friend else { return nil }
        guard let userIdStr = managedUser.userId else { return nil }
        guard let friendIdStr = managedFriend.userId else { return nil }
        return Friendship(userId: UserId(string: userIdStr), friendId: UserId(string: friendIdStr))
    }
    
    func mapToManagedObject(_ managedObject: ManagedFriend, mappingContext: CoreDataMappingContext) throws {
        managedObject.user = try mappingContext.syncOneManaged(predicate: NSPredicate(format: "userId == %@", userId.asString))
        managedObject.friend = try mappingContext.syncOneManaged(predicate: NSPredicate(format: "userId == %@", friendId.asString))
    }
    
    func getIdPredicate() -> NSPredicate {
        return NSPredicate(format: "user.userId == %@ && friend.userId == %@", userId.asString, friendId.asString)
    }
}

// MARK: - DynamoConvertible

extension Friendship: DynamoConvertible {
    static func toEntity(awsObject: AWSFriend) -> Friendship? {
        guard let userIdStr = awsObject._userId else { return nil }
        guard let friendIdStr = awsObject._friendId else { return nil }
        return Friendship(userId: UserId(string: userIdStr), friendId: UserId(string: friendIdStr))
    }
    
    func toDynamoDb() -> AWSFriend? {
        let awsFriend: AWSFriend = AWSFriend()
        awsFriend._userId = userId.asString
        awsFriend._friendId = friendId.asString
        return awsFriend
    }
}
