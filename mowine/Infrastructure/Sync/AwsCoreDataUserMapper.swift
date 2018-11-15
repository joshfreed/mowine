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
    
    func create(from remote: AWSUser) -> ManagedUser {
        let managedUser = ManagedUser(context: context)
        map(from: remote, to: managedUser)
        return managedUser
    }
    
    func construct(from local: ManagedUser) -> AWSUser {
        let awsUser: AWSUser = AWSUser()
        map(from: local, to: awsUser)
        return awsUser
    }
    
    func map(from remote: AWSUser, to local: ManagedUser) {
        local.userId = remote._userId
        local.emailAddress = remote._email
        local.firstName = remote._firstName
        local.lastName = remote._lastName
        if let updatedAtStr = remote._updatedAt {
            local.updatedAt = ISO8601DateFormatter().date(from: updatedAtStr) ?? Date()
        }
    }
    
    func map(from local: ManagedUser, to remote: AWSUser) {
        remote._userId = local.userId
        remote._email = local.emailAddress
        remote._firstName = local.firstName
        remote._lastName = local.lastName
        if let updatedAt = local.updatedAt {
            remote._updatedAt = ISO8601DateFormatter().string(from: updatedAt)
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

extension ManagedUser: CoreDataSyncable {
    func getId() -> String? {
        return userId
    }

    static func getIdProperty() -> String {
        return "userId"
    }
}
