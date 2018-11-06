//
//  Wine.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import UIKit
import CoreData

final class Wine: Equatable {
    let id: UUID
    let userId: UserId
    var type: WineType {didSet{ modified() }}
    var variety: WineVariety? {didSet{ modified() }}
    var name: String {didSet{ modified() }}
    var rating: Double {didSet{ modified() }}
    var location: String? {didSet{ modified() }}
    var notes: String? {didSet{ modified() }}
    var price: String? {didSet{ modified() }}
    var pairings: [String] = [] {didSet{ modified() }}
    var thumbnail: Data? {didSet{ modified() }}
    private(set) var createdAt: Date
    private(set) var syncState: SyncStatus = .synced
    var updatedAt: Date
    
    var varietyName: String {
        return variety?.name ?? type.name
    }
    
    init(id: UUID, userId: UserId, type: WineType, name: String, rating: Double) {
        self.id = id
        self.userId = userId
        self.type = type
        self.name = name
        self.rating = rating
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init(userId: UserId, type: WineType, variety: WineVariety, name: String, rating: Double) {
        self.id = UUID()
        self.userId = userId
        self.type = type
        self.variety = variety
        self.name = name
        self.rating = rating
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init(userId: UserId, type: WineType, name: String, rating: Double) {
        self.id = UUID()
        self.userId = userId
        self.type = type
        self.name = name
        self.rating = rating
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    public static func ==(lhs: Wine, rhs: Wine) -> Bool {
        return lhs.id == rhs.id
    }
    
    private func modified() {
        updatedAt = Date()
        if syncState == .synced {
            syncState = .modified
        }
    }
    
    func synced() {
        syncState = .synced
    }
    
    func delete() {
        syncState = .deleted
    }
}

extension Wine: Syncable {
    var identifier: String {
        return id.uuidString
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
        wine.createdAt = managedObject.createdAt!
        wine.updatedAt = managedObject.updatedAt!
        wine.syncState = SyncStatus(rawValue: Int(managedObject.syncStatus))!
        
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
        managedObject.createdAt = createdAt
        managedObject.updatedAt = updatedAt
        managedObject.syncStatus = Int16(syncState.rawValue)
        
        if let price = price {
            managedObject.price = NSDecimalNumber(string: price)
        } else {
            managedObject.price = nil
        }
        
        let user = User(id: userId, emailAddress: "") // todo - make this an actual association on Wine!!!!
        managedObject.user = try mappingContext.syncOne(user)
        managedObject.type = try mappingContext.syncOne(type)
        assert(managedObject.user != nil)
        assert(managedObject.type != nil)
        
        if let variety = variety {
            managedObject.variety = try mappingContext.syncOne(variety)
        } else {
            managedObject.variety = nil
        }
        
        /*
        let managedPairings: [ManagedFood] = pairings.map {
            let mf = ManagedFood(context: context)
            mf.name = $0
            return mf
        }
        managedObject.pairings = NSSet(array: managedPairings)
 */
    }
    
    func getIdPredicate() -> NSPredicate {
        return NSPredicate(format: "wineId == %@", id.uuidString)
    }
}

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
