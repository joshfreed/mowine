//
//  Mocks.swift
//  mowineTests
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
@testable import mowine
import JFLib

class MockWineRepository: WineRepository {
    func getMyWines(completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        completion(.success(wine))
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        completion(.success)
    }
}

class MockWineTypeRepository: WineTypeRepository {
    func getAll(completion: @escaping (Result<[WineType]>) -> ()) {
        
    }
    
    func getWineType(named name: String, completion: @escaping (Result<WineType?>) -> ()) {
        
    }
}

class MockWineVarietyRepository: WineVarietyRepository {
    var varieties: [WineVariety] = []
    
    func getVarieties(of type: WineType, completion: @escaping (Result<[WineVariety]>) -> ()) {
        
    }
    
    func getVariety(named name: String, completion: @escaping (Result<WineVariety>) -> ()) {
        if let found = varieties.first(where: { $0.name == name }) {
            completion(.success(found))
        } else {
            
        }
    }
}
