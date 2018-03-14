//
//  MemoryWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

class MemoryWineRepository: WineRepository {
    private var wines: [Wine] = []
    
    func getMyWines(completion: @escaping (Result<[Wine]>) -> ()) {
        completion(.success(wines))
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        if let index = wines.index(of: wine) {
            wines[index] = wine
            // maybe not necessary since it's a class and thus by reference?!?!?!?
        } else {
            wines.append(wine)
        }
        
        completion(.success(wine))
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        if let index = wines.index(of: wine) {
            wines.remove(at: index)
        }
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
}
