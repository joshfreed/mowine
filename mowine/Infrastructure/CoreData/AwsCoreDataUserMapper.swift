//
//  AwsCoreDataUserMapper.swift
//  mowine
//
//  Created by Josh Freed on 11/9/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData

class AwsCoreDataUserMapper: DataMapper {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(from source: AWSUser) -> ManagedUser {
        let managedUser = ManagedUser(context: context)
        map(from: source, to: managedUser)
        return managedUser
    }
    
    func map(from source: AWSUser, to destination: ManagedUser) {
        destination.userId = source._userId
        destination.emailAddress = source._email
        destination.firstName = source._firstName
        destination.lastName = source._lastName
        if let updatedAtStr = source._updatedAt {
            destination.updatedAt = ISO8601DateFormatter().date(from: updatedAtStr) ?? Date()
        }
    }
}

extension AWSUser: RemoteObject {
    func getId() -> String? {
        return _userId
    }
    
    func getUpdatedAt() -> Date? {
        return ISO8601DateFormatter().date(from: _updatedAt ?? "")
    }
}

extension ManagedUser: LocalObject {
    func getId() -> String? {
        return userId
    }
    
    func isCreated() -> Bool {
        return syncState == Int16(SyncStatus.created.rawValue)
    }
    
    func isModified(after date: Date) -> Bool {
        guard let updatedAt = updatedAt else { return false }
        return syncState == Int16(SyncStatus.modified.rawValue) && updatedAt > date
    }
}

extension ManagedUser: CoreDataObject {
    static func getIdProperty() -> String {
        return "userId"
    }
}
