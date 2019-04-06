//
//  Wine.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import UIKit
import SwiftyBeaver

typealias WineId = StringIdentity

final class Wine: Equatable {
    let id: WineId
    let userId: UserId
    var type: WineType
    var variety: WineVariety?
    var name: String
    var rating: Double
    var location: String?
    var notes: String?
    var price: String?
    var pairings: [String] = []
//    var thumbnail: Data?
    var createdAt: Date = Date()
    
    var varietyName: String {
        return variety?.name ?? type.name
    }
    
    init(id: WineId, userId: UserId, type: WineType, name: String, rating: Double) {
        self.id = id
        self.userId = userId
        self.type = type
        self.name = name
        self.rating = rating
    }
    
    init(userId: UserId, type: WineType, variety: WineVariety, name: String, rating: Double) {
        self.id = WineId()
        self.userId = userId
        self.type = type
        self.variety = variety
        self.name = name
        self.rating = rating
    }
    
    init(userId: UserId, type: WineType, name: String, rating: Double) {
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
