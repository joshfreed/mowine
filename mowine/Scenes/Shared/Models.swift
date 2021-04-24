//
//  Models.swift
//  mowine
//
//  Created by Josh Freed on 2/20/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import Model

struct WineViewModel {
    var name: String
    var rating: Double
    var typeName: String?
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
    
    public static func from(model wine: Wine) -> WineViewModel {
        var viewModel = WineViewModel(name: wine.name, rating: wine.rating)
        viewModel.typeName = wine.type.name
        viewModel.variety = wine.variety?.name
        viewModel.location = wine.location
        viewModel.price = wine.price
        viewModel.notes = wine.notes
        viewModel.pairings = wine.pairings
        return viewModel
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
    
    public static func from(model wineType: WineType) -> WineTypeViewModel {
        return WineTypeViewModel(name: wineType.name, varieties: wineType.varieties.map({ $0.name }))
    }
}
