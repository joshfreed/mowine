//
//  Wine.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import UIKit
import CoreData
import SwiftyBeaver

final class Wine: Equatable {
    let id: UUID
    let userId: UserId
    var type: WineType
    var variety: WineVariety?
    var name: String
    var rating: Double
    var location: String?
    var notes: String?
    var price: String?
    var pairings: [String] = []
    var thumbnail: Data?
    
    var varietyName: String {
        return variety?.name ?? type.name
    }
    
    init(id: UUID, userId: UserId, type: WineType, name: String, rating: Double) {
        self.id = id
        self.userId = userId
        self.type = type
        self.name = name
        self.rating = rating
    }
    
    init(userId: UserId, type: WineType, variety: WineVariety, name: String, rating: Double) {
        self.id = UUID()
        self.userId = userId
        self.type = type
        self.variety = variety
        self.name = name
        self.rating = rating
    }
    
    init(userId: UserId, type: WineType, name: String, rating: Double) {
        self.id = UUID()
        self.userId = userId
        self.type = type
        self.name = name
        self.rating = rating
    }
    
    public static func ==(lhs: Wine, rhs: Wine) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Wine: CoreDataConvertible {
    static func toEntity(managedObject: ManagedWine) -> Wine? {
        guard
            let id = managedObject.wineId,
            let name = managedObject.name,
            let managedType = managedObject.type,
            let type = CoreDataWineTypeTranslator.makeModel(from: managedType),
            let user = managedObject.user, let userIdStr = user.userId
        else {
            return nil
        }
        
        let userId = UserId(string: userIdStr)
        let wine = Wine(id: id, userId: userId, type: type, name: name, rating: managedObject.rating)
        
        if let managedVariety = managedObject.variety {
            wine.variety = WineVariety.toEntity(managedObject: managedVariety)
        }
        
        wine.location = managedObject.location
        wine.price = managedObject.price != nil ? managedObject.price!.stringValue : nil
        wine.notes = managedObject.notes
        wine.thumbnail = managedObject.thumbnail
        
        if let pairingSet = managedObject.pairings, let pairings = Array(pairingSet) as? [ManagedFood] {
            wine.pairings = pairings.compactMap { $0.name }
        }
        
        return wine
    }
    
    func mapToManagedObject(_ managedObject: ManagedWine, mappingContext: CoreDataMappingContext) throws {
        managedObject.wineId = id
        managedObject.name = name
        managedObject.rating = rating
        managedObject.location = location
        managedObject.notes = notes
        managedObject.thumbnail = thumbnail
        
        if let price = price {
            managedObject.price = NSDecimalNumber(string: price)
        } else {
            managedObject.price = nil
        }
        
        managedObject.user = try mappingContext.syncOneManaged(predicate: NSPredicate(format: "userId == %@", userId.asString))
        managedObject.type = try mappingContext.syncOne(type)
        assert(managedObject.user != nil)
        assert(managedObject.type != nil)
        
        if let variety = variety {
            managedObject.variety = try mappingContext.syncOne(variety)
        } else {
            managedObject.variety = nil
        }
        
        let managedPairings: [ManagedFood] = pairings.map {
            let mf = ManagedFood(context: mappingContext.context)
            mf.name = $0
            return mf
        }
        managedObject.pairings = NSSet(array: managedPairings)
        
        managedObject.createdAt = Date()
        managedObject.updatedAt = Date()
    }
    
    func getIdPredicate() -> NSPredicate {
        return NSPredicate(format: "wineId == %@", id as CVarArg)
    }
}

/*
extension Wine: DynamoConvertible {
    static func toEntity(awsObject: AWSWine) -> Wine? {
        guard let wineIdStr = awsObject._wineId, let wineId = UUID(uuidString: wineIdStr) else {
            return nil
        }
        guard let name = awsObject._name else {
            return nil
        }
        guard let typeName = awsObject._type else {
            return nil
        }
        guard let rating = awsObject._rating else {
            return nil
        }
        guard let userIdStr = awsObject._userId else {
            return nil
        }
        
        let userId = UserId(string: userIdStr)
        let wineType = WineType(name: typeName, varieties: [])
        
        let wine = Wine(id: wineId, userId: userId, type: wineType, name: name, rating: rating.doubleValue)
        
        if let varietyName = awsObject._variety {
            wine.variety = WineVariety(name: varietyName)
        }
        
        wine.location = awsObject._location
        wine.notes = awsObject._notes
        wine.price = awsObject._price
        wine.pairings = Array(awsObject._pairings ?? [])
        wine.thumbnail = awsObject._thumbnail
        
        if let createdAt = awsObject._createdAt {
            if let date = ISO8601DateFormatter().date(from: createdAt) {
                wine.createdAt = date
            } else {
                print("Could not parse date from createdAt field: \(createdAt)")
            }
        }
        if let updatedAt = awsObject._updatedAt {
            if let date = ISO8601DateFormatter().date(from: updatedAt) {
                wine.updatedAt = date
            } else {
                print("Could not parse date from updatedAt field: \(updatedAt)")
            }
        }
        
        wine.synced()
        
        return wine
    }
    
    func toDynamoDb() -> AWSWine? {
        let awsWine: AWSWine = AWSWine()
        awsWine._wineId = id.uuidString
        awsWine._userId = userId.asString
        awsWine._name = name
        awsWine._rating = NSNumber(value: rating)
        awsWine._type = type.name
        awsWine._variety = variety?.name
        awsWine._location = location
        awsWine._notes = notes
        awsWine._price = price
        awsWine._thumbnail = thumbnail
        
        if pairings.count > 0 {
            awsWine._pairings = Set(pairings)
        }
        
        awsWine._createdAt = ISO8601DateFormatter().string(from: createdAt)
        awsWine._updatedAt = ISO8601DateFormatter().string(from: updatedAt)
        
        return awsWine
    }
}

extension ManagedWine {
    override public func willSave() {
        SwiftyBeaver.verbose("NSManagedObject::willSave()")
        if hasPersistentChangedValues {
            SwiftyBeaver.verbose("ManagedWine has changes")
            
            if let updatedAt = updatedAt {
                if updatedAt.timeIntervalSince(Date()) > 10.0 {
                    self.updatedAt = Date()
                }
            } else {
                self.updatedAt = Date()
            }
            
            if syncStatus != Int16(SyncStatus.modified.rawValue) {
                syncStatus = Int16(SyncStatus.modified.rawValue)
            }
            
            SwiftyBeaver.verbose(changedValues())
        }
    }
}
*/
