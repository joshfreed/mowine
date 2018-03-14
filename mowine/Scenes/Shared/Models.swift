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
    var price: Double?
    var notes: String?
    var image: UIImage?
    var pairings: [String] = []
    
    init(name: String, rating: Double) {
        self.name = name
        self.rating = rating        
    }
}

struct WineListViewModel {
    var name: String
    var rating: Double
    var type: String
    var thumbnail: UIImage?
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
