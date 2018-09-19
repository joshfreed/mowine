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
    var type: WineType
    var variety: WineVariety?
    var name: String
    var rating: Double
    var location: String?
    var notes: String?
    var price: String?
    var pairings: [String] = []
    var createdAt: Date?
    var thumbnail: Data?
    
    var varietyName: String {
        return variety?.name ?? type.name
    }
    
    init(id: UUID, type: WineType, name: String, rating: Double) {
        self.id = id
        self.type = type
        self.name = name
        self.rating = rating
        self.createdAt = Date()
    }
    
    init(type: WineType, variety: WineVariety, name: String, rating: Double) {
        self.id = UUID()
        self.type = type
        self.variety = variety
        self.name = name
        self.rating = rating
        self.createdAt = Date()
    }
    
    init(type: WineType, name: String, rating: Double) {
        self.id = UUID()
        self.type = type
        self.name = name
        self.rating = rating
        self.createdAt = Date()
    }
    
    public static func ==(lhs: Wine, rhs: Wine) -> Bool {
        return lhs.id == rhs.id
    }
}
