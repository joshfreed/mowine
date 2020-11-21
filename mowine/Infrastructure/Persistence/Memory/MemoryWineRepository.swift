//
//  MemoryWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

class MemoryWineRepository: WineRepository {
    private var wines: [Wine] = []
    
    func add(_ wine: Wine, completion: @escaping (Result<Wine, Error>) -> ()) {
        wines.append(wine)
    }
    
    func delete(_ wine: Wine, completion: @escaping (Result<Void, Error>) -> ()) {
        if let index = wines.firstIndex(of: wine) {
            wines.remove(at: index)
        }
    }
    
    func getWine(by id: WineId, completion: @escaping (Result<Wine, Error>) -> ()) {
        if let wine = wines.first(where: { $0.id == id }) {
            completion(.success(wine))
        } else {
            completion(.failure(WineRepositoryError.notFound))
        }
    }

    func save(_ wine: Wine, completion: @escaping (Result<Wine, Error>) -> ()) {
        guard let index = wines.firstIndex(of: wine) else {
            return
        }
        
        // maybe not necessary since it's a class and thus by reference?!?!?!?
        wines[index] = wine
        
        completion(.success(wine))
    }
    
    func getWines(userId: UserId, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        completion(.success(wines))
        return FakeRegistration()
    }

    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine], Error>) -> ()) {
        
    }
    
    func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId, completion: @escaping (Result<[String], Error>) -> ()) {
        
    }
}
