//
//  Wine.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import UIKit

class Wine: Equatable {
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
    private(set) var updatedAt: Date
    private(set) var syncStatus: SyncStatus = .created
    
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
        if syncStatus == .synced {
            syncStatus = .modified
        }
    }
    
    func synced() {
        syncStatus = .synced
    }
    
    func delete() {
        syncStatus = .deleted
    }
}

// MARK: - ManagedWine

extension Wine {
    func map(to managedWine: ManagedWine, coreData: CoreDataService) {
        managedWine.wineId = id
        managedWine.name = name
        managedWine.rating = rating
        managedWine.location = location
        managedWine.notes = notes
        managedWine.thumbnail = thumbnail
        managedWine.createdAt = createdAt
        managedWine.updatedAt = updatedAt
        managedWine.syncStatus = Int16(syncStatus.rawValue)
        
        if let price = price {
            managedWine.price = NSDecimalNumber(string: price)
        } else {
            managedWine.price = nil
        }
        
        managedWine.user = coreData.findManagedUser(by: userId)
        if (managedWine.user == nil) {
            fatalError("User \(userId) not in db")
        }
        
        managedWine.type = coreData.getManagedType(for: type)
        if (managedWine.type == nil) {
            fatalError("Wine type \(type.name) not in db")
        }
        
        if let variety = variety {
            managedWine.variety = coreData.getManagedVariety(for: variety)
        } else {
            managedWine.variety = nil
        }
        
        let managedPairings: [ManagedFood] = pairings.map {
            let mf = ManagedFood(context: coreData.context)
            mf.name = $0
            return mf
        }
        managedWine.pairings = NSSet(array: managedPairings)
    }
    
    static func fromManagedWine(_ entity: ManagedWine) -> Wine? {
        guard
            let id = entity.wineId,
            let name = entity.name,
            let managedType = entity.type,
            let type = CoreDataWineTypeTranslator.makeModel(from: managedType),
            let user = entity.user, let userIdStr = user.userId
        else {
            return nil
        }
        
        let userId = UserId(string: userIdStr)
        let wine = Wine(id: id, userId: userId, type: type, name: name, rating: entity.rating)
        
        if let managedVariety = entity.variety {
            wine.variety = CoreDataVarietyTranslator.map(from: managedVariety)
        }
        
        wine.location = entity.location
        wine.price = entity.price != nil ? entity.price!.stringValue : nil
        wine.notes = entity.notes
        wine.thumbnail = entity.thumbnail
        wine.createdAt = entity.createdAt!
        wine.updatedAt = entity.updatedAt!
        wine.syncStatus = SyncStatus(rawValue: Int(entity.syncStatus))!
        
        if let pairingSet = entity.pairings, let pairings = Array(pairingSet) as? [ManagedFood] {
            wine.pairings = pairings.compactMap { $0.name }
        }
        
        return wine
    }
}

// MARK: - AWSWine

extension Wine {
    func toAWSWine() -> AWSWine {
        let awsWine: AWSWine = AWSWine()
        awsWine._wineId = id.uuidString
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
    
    static func fromAWSWine(_ awsWine: AWSWine) -> Wine? {
        guard let wineIdStr = awsWine._wineId, let wineId = UUID(uuidString: wineIdStr) else {
            return nil
        }
        guard let name = awsWine._name else {
            return nil
        }
        guard let typeName = awsWine._type else {
            return nil
        }
        guard let rating = awsWine._rating else {
            return nil
        }
        guard let userIdStr = awsWine._userId else {
            return nil
        }
        
        let userId = UserId(string: userIdStr)
        let wineType = WineType(name: typeName, varieties: [])
        
        let wine = Wine(id: wineId, userId: userId, type: wineType, name: name, rating: rating.doubleValue)
        
        if let varietyName = awsWine._variety {
            wine.variety = WineVariety(name: varietyName)
        }
        
        wine.location = awsWine._location
        wine.notes = awsWine._notes
        wine.price = awsWine._price
        wine.pairings = Array(awsWine._pairings ?? [])
        wine.thumbnail = awsWine._thumbnail
        
        if let createdAt = awsWine._createdAt {
            if let date = ISO8601DateFormatter().date(from: createdAt) {
                wine.createdAt = date
            } else {
                print("Could not parse date from createdAt field: \(createdAt)")
            }
        }
        if let updatedAt = awsWine._updatedAt {
            if let date = ISO8601DateFormatter().date(from: updatedAt) {
                wine.updatedAt = date
            } else {
                print("Could not parse date from updatedAt field: \(updatedAt)")
            }
        }
        
        wine.synced()
        
        return wine
    }
}
