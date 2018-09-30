//
//  User.swift
//  mowine
//
//  Created by Josh Freed on 3/1/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import CoreData

struct User: Equatable {
    let id: UserId
    var emailAddress: String
    var firstName: String?
    var lastName: String?
    var profilePicture: UIImage?
    private(set) var friends: [User] = []
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
        if friends.contains(user) {
            return
        }
        
        friends.append(user)
    }
    
    mutating func removeFriend(user: User) {
        if let index = friends.index(of: user) {
            friends.remove(at: index)
        }
    }
}

struct UserId: Hashable, CustomStringConvertible {
    let identityId: String
    
    var description: String {
        return identityId
    }
    
    var asString: String {
        return description
    }
    
    init() {
        identityId = UUID().uuidString
    }
    
    init(string: String) {
        identityId = string
    }
    
    var hashValue: Int {
        return identityId.hashValue
    }
    
    static func ==(lhs: UserId, rhs: UserId) -> Bool {
        return lhs.identityId == rhs.identityId
    }
}

extension User: Syncable {
    var identifier: String {
        return id.asString
    }
}

extension User {
    func toManagedUser(_ managedUser: ManagedUser) {
        mapToManagedObject(managedUser)
    }
    
    static func fromCoreData(_ managedUser: ManagedUser) -> User? {
        return toEntity(managedObject: managedUser)
    }
}

extension User: CoreDataConvertible {
    static func toEntity(managedObject: ManagedUser) -> User? {
        guard let userIdStr = managedObject.userId else {
            return nil
        }
        
        let userId = UserId(string: userIdStr)
        var user = User(id: userId, emailAddress: managedObject.emailAddress ?? "")
        user.firstName = managedObject.firstName
        user.lastName = managedObject.lastName
        return user
    }
    
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedUser? {
        let managedUser = ManagedUser(context: context)
        mapToManagedObject(managedUser)
        return managedUser
    }
    
    func mapToManagedObject(_ managedObject: ManagedUser) {
        managedObject.userId = id.asString
        managedObject.emailAddress = emailAddress
        managedObject.firstName = firstName
        managedObject.lastName = lastName
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
//        if let updatedAt = awsObject._updatedAt {
//            if let date = ISO8601DateFormatter().date(from: updatedAt) {
//                user.updatedAt = date
//            } else {
//                print("Could not parse date from updatedAt field: \(updatedAt)")
//            }
//        }
        
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
