//
//  WineBuilder.swift
//  mowineTests
//
//  Created by Josh Freed on 2/22/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
@testable import mowine

class WineBuilder {
    private var id: UUID?
    private var type = WineType(name: "Red", varieties: [])
    private var variety: WineVariety?
    private var name: String?
    private var rating: Double = 3
    private var location: String?
    private var notes: String?
    private var price: Double?
    private var photo: Data?
    private var thumbnail: Data?
    private var pairings: [String] = []
    
    static func aWine() -> WineBuilder {
        return WineBuilder()
    }
    
    func build() -> Wine {
        if name == nil {
            let num = arc4random_uniform(10000) + 1
            name = "Wine\(num)"
        }
        
        var wine: Wine
        
        if let id = id {
            wine = Wine(id: id, type: type, name: name!, rating: rating)
        } else {
            wine = Wine(type: type, name: name!, rating: rating)
        }
        
        wine.variety = variety
        wine.location = location
        wine.notes = notes
        wine.price = price
        wine.photo = photo
        wine.thumbnail = thumbnail
        wine.pairings = pairings
        
        return wine
    }
    
    func withType(_ type: WineType) -> WineBuilder {
        self.type = type
        return self
    }
    
    func withVariety(_ variety: WineVariety) -> WineBuilder {
        self.variety = variety
        return self
    }
    
    func withName(_ name: String) -> WineBuilder {
        self.name = name
        return self
    }
    
    func withRating(_ rating: Double) -> WineBuilder {
        self.rating = rating
        return self
    }
    
    func withLocation(_ location: String) -> WineBuilder {
        return self
    }
    
    func withNotes(_ notes: String) -> WineBuilder {
        return self
    }
    
    func withPrice(_ price: Double) -> WineBuilder {
        return self
    }
    
    func withPhoto() -> WineBuilder {
        photo = Data(repeating: 99, count: 11)
        thumbnail = Data(repeating: 99, count: 2)
        return self
    }
    
    func pairedWith(_ foods: [String]) -> WineBuilder {
        self.pairings = foods
        return self
    }
}
