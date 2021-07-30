//
//  MemoryWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import Model

class MemoryWineRepository: WineRepository {
    var wines: [Wine] = []
    
    func add(_ wine: Wine) async throws {
        wines.append(wine)
    }
    
    func delete(_ wine: Wine, completion: @escaping (Result<Void, Error>) -> ()) {
        if let index = wines.firstIndex(of: wine) {
            wines.remove(at: index)
        }
        completion(.success(()))
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
        completion(.success(wines.filter { $0.userId == userId }))
        return FakeRegistration()
    }

    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let matched = self.wines.filter { $0.userId == userId && $0.type == wineType }
            completion(.success(matched))
        }
        return FakeRegistration()
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine], Error>) -> ()) {
        
    }
    
    func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId, completion: @escaping (Result<[String], Error>) -> ()) {
        
    }
}
