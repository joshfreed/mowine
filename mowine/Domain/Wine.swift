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
    var photo: Data?
    var thumbnail: Data?
    var location: String?
    var notes: String?
    var price: Double?
    var pairings: [String] = []
    
    var varietyName: String {
        return variety?.name ?? type.name
    }
    
    init(id: UUID, type: WineType, name: String, rating: Double) {
        self.id = id
        self.type = type
        self.name = name
        self.rating = rating
    }
    
    init(type: WineType, variety: WineVariety, name: String, rating: Double) {
        self.id = UUID()
        self.type = type
        self.variety = variety
        self.name = name
        self.rating = rating        
    }
    
    init(type: WineType, name: String, rating: Double) {
        self.id = UUID()
        self.type = type
        self.name = name
        self.rating = rating
    }
    
    public static func ==(lhs: Wine, rhs: Wine) -> Bool {
        return lhs.id == rhs.id
    }
}

extension WineListViewModel {
    static func from(wine: Wine) -> WineListViewModel {
        var image: UIImage? = nil
        if let thumbnail = wine.thumbnail {
            image = UIImage(data: thumbnail)
        }
        return WineListViewModel(
            id: wine.id.uuidString,
            name: wine.name,
            rating: wine.rating,
            type: wine.varietyName,
            thumbnail: image
        )
    }
}
