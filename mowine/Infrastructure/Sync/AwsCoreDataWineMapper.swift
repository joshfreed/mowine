//
//  AwsCoreDataWineMapper.swift
//  mowine
//
//  Created by Josh Freed on 11/15/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData

class AwsCoreDataWineMapper: DataMapper {
    let context: NSManagedObjectContext
    let coreDataWorker: CoreDataWorker
    let mappingContext: CoreDataMappingContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.coreDataWorker = CoreDataWorker()
        self.mappingContext = CoreDataMappingContext(worker: coreDataWorker, context: context)
    }
    
    func create(from remote: AWSWine) throws -> ManagedWine {
        let managedObject = ManagedWine(context: context)
        try map(from: remote, to: managedObject)
        return managedObject
    }
    
    func construct(from local: ManagedWine) throws -> AWSWine {
        let awsWine: AWSWine = AWSWine()
        try map(from: local, to: awsWine)
        return awsWine
    }
    
    func map(from remote: AWSWine, to local: ManagedWine) throws {
        if let wineId = remote._wineId {
            local.wineId = UUID(uuidString: wineId)
        }
        if let userId = remote._userId {
            local.user = try mappingContext.syncOneManaged(predicate: NSPredicate(format: "userId == %@", userId))
        }
        local.name = remote._name
        if let rating = remote._rating {
            local.rating = rating.doubleValue
        }
        if let typeName = remote._type {
            local.type = try mappingContext.syncOneManaged(predicate: NSPredicate(format: "name == %@", typeName))
        }
        if let varietyName = remote._variety {
            local.variety = try mappingContext.syncOneManaged(predicate: NSPredicate(format: "name == %@", varietyName))
        }
        local.location = remote._location
        local.notes = remote._notes
        local.price = remote._price
        local.thumbnail = remote._thumbnail
        if let pairings = remote._pairings {
            let managedPairings: [ManagedFood] = try mappingContext.syncSetManaged(predicate: "%K == %@", key: "name", values: Array(pairings))
            local.pairings = NSSet(array: managedPairings)
        }
        if let updatedAtStr = remote._updatedAt {
            local.updatedAt = ISO8601DateFormatter().date(from: updatedAtStr) ?? Date()
        }
    }
    
    func map(from local: ManagedWine, to remote: AWSWine) throws {
        remote._wineId = local.wineId?.uuidString
        remote._userId = local.user?.userId
        remote._name = local.name
        remote._rating = NSNumber(value: local.rating)
        remote._type = local.type?.name
        remote._variety = local.variety?.name
        remote._location = local.location
        remote._notes = local.notes
        remote._price = local.price
        remote._thumbnail = local.thumbnail
        
        if let pairingSet = local.pairings, let pairings = Array(pairingSet) as? [ManagedFood], pairings.count > 0 {
            remote._pairings = Set(pairings.compactMap({ $0.name }))
        } else {
            remote._pairings = nil
        }

        if let updatedAt = local.updatedAt {
            remote._updatedAt = ISO8601DateFormatter().string(from: updatedAt)
        }
    }
}

extension AWSWine: RemoteObject {
    func getId() -> String? {
        return _wineId
    }
    
    func getUpdatedAt() -> Date? {
        return ISO8601DateFormatter().date(from: _updatedAt ?? "")
    }
}

extension ManagedWine: CoreDataSyncable {
    static func getIdProperty() -> String {
        return "wineId"
    }
    
    func getId() -> String? {
        return wineId?.uuidString
    }
}
