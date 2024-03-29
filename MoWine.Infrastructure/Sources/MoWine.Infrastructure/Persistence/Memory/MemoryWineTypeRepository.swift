//
//  MemoryWineTypeRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Application
import MoWine_Domain

public class MemoryWineTypeRepository: WineTypeRepository {
    public private(set) lazy var types: [WineType] = {
        let red = WineType(name: "Red", varieties: [
            WineVariety(name: "Cabernet Sauvignon"),
            WineVariety(name: "Chianti"),
            WineVariety(name: "Malbec"),
            WineVariety(name: "Merlot"),
            WineVariety(name: "Pinot Nior"),
            WineVariety(name: "Red Blend")
        ])
        
        let white = WineType(name: "White", varieties: [
            WineVariety(name: "Chardonnay"),
            WineVariety(name: "Gewürztraminer"),
            WineVariety(name: "Pinot Blanc"),
            WineVariety(name: "Pinot Grigio"),
            WineVariety(name: "Riesling"),
            WineVariety(name: "Sauvignon Blanc"),
            WineVariety(name: "Moscato"),
            WineVariety(name: "White Blend")
        ])
        
        let rose = WineType(name: "Rosé", varieties: [])
        
        let bubbly = WineType(name: "Bubbly", varieties: [
            WineVariety(name: "Champagne"),
            WineVariety(name: "Prosecco"),
            WineVariety(name: "Sparkling"),
        ])
        
        let other = WineType(name: "Other", varieties: [])
        
        return [red, white, rose, bubbly, other]
    }()

    public init() {}
    
    // MARK: WineTypeRepository

    public func getAll() async throws -> [WineType] {
        types
    }

    public func getWineType(named name: String) async throws -> WineType? {
        types.first { $0.name == name }
    }

    func getAll(completion: @escaping (Result<[WineType], Error>) -> ()) {
        completion(.success(types))
    }
    
    func getWineType(named name: String, completion: @escaping (Result<WineType?, Error>) -> ()) {
        for type in types {
            if type.name == name {
                completion(.success(type))
            }
        }
        
        completion(.success(nil))
    }
}
