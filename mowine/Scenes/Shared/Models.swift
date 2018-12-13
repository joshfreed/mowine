//
//  Models.swift
//  mowine
//
//  Created by Josh Freed on 2/20/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

struct WineViewModel {
    var name: String
    var rating: Double
    var type: WineTypeViewModel?
    var variety: String?
    var location: String?
    var price: String?
    var notes: String?
    var image: UIImage?
    var pairings: [String] = []
    
    init(name: String, rating: Double) {
        self.name = name
        self.rating = rating        
    }
}

struct WineListViewModel: Equatable {
    var id: String
    var name: String
    var rating: Double
    var type: String
    var thumbnail: Data?
    
    public static func ==(lhs: WineListViewModel, rhs: WineListViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension WineListViewModel {
    static func from(wine: Wine) -> WineListViewModel {
        return WineListViewModel(
            id: wine.id.asString,
            name: wine.name,
            rating: wine.rating,
            type: wine.varietyName,
            thumbnail: nil
        )
    }
}

struct WineTypeViewModel: Equatable, CustomStringConvertible {
    var name: String
    var varieties: [String]
    var description: String {
        return name
    }
    
    public static func ==(lhs: WineTypeViewModel, rhs: WineTypeViewModel) -> Bool {
        return lhs.name == rhs.name
    }
}
