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
    
    func add(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        wines.append(wine)
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        if let index = wines.index(of: wine) {
            wines.remove(at: index)
        }
    }
    
    func getWine(by id: UUID, completion: @escaping (Result<Wine>) -> ()) {
        if let wine = wines.first(where: { $0.id == id }) {
            completion(.success(wine))
        } else {
            completion(.failure(WineRepositoryError.notFound))
        }
    }

    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        guard let index = wines.index(of: wine) else {
            return
        }
        
        // maybe not necessary since it's a class and thus by reference?!?!?!?
        wines[index] = wine
        
        completion(.success(wine))
    }
    
    func getWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        completion(.success(wines))
    }

    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
}
