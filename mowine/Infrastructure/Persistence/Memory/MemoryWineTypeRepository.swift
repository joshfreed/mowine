//
//  MemoryWineTypeRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

class MemoryWineTypeRepository: WineTypeRepository, WineVarietyRepository {
    private lazy var types: [WineType] = {
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
            WineVariety(name: "Prosecco")
        ])
        
        let other = WineType(name: "Other", varieties: [])
        
        return [red, white, rose, bubbly, other]
    }()
    
    // MARK: WineTypeRepository
    
    func getAll(completion: @escaping (Result<[WineType]>) -> ()) {
        completion(.success(types))
    }
    
    func getWineType(named name: String, completion: @escaping (Result<WineType?>) -> ()) {
        for type in types {
            if type.name == name {
                completion(.success(type))
            }
        }
        
        completion(.success(nil))
    }
    
    // MARK: WineVarietyRepository
    
    func getVariety(named name: String, completion: @escaping (Result<WineVariety>) -> ()) {
        for type in types {
            for variety in type.varieties {
                if variety.name == name {
                    completion(.success(variety))
                }
            }
        }
        
//        completion(.failure())
    }
}
