//
//  Wine.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation

public typealias WineId = StringIdentity

public final class Wine: Equatable {
    public let id: WineId
    public let userId: UserId
    public var type: WineType
    public var variety: WineVariety?
    public var name: String
    public var rating: Double
    public var location: String?
    public var notes: String?
    public var price: String?
    public var pairings: [String] = []
    public var createdAt: Date = Date()
    
    public var varietyName: String {
        return variety?.name ?? type.name
    }
    
    public init(id: WineId, userId: UserId, type: WineType, name: String, rating: Double) {
        self.id = id
        self.userId = userId
        self.type = type
        self.name = name
        self.rating = rating
    }
    
    public init(userId: UserId, type: WineType, variety: WineVariety, name: String, rating: Double) {
        self.id = WineId()
        self.userId = userId
        self.type = type
        self.variety = variety
        self.name = name
        self.rating = rating
    }
    
    public init(userId: UserId, type: WineType, name: String, rating: Double) {
        self.id = WineId()
        self.userId = userId
        self.type = type
        self.name = name
        self.rating = rating
    }
    
    public static func ==(lhs: Wine, rhs: Wine) -> Bool {
        return lhs.id == rhs.id
    }
}
