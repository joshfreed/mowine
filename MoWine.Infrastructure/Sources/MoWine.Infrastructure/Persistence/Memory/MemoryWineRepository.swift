//
//  MemoryWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Application
import MoWine_Domain

public class MemoryWineRepository: WineRepository {
    var wines: [Wine] = []

    public init() {}

    public func add(_ wine: Wine) async throws {
        guard !wines.contains(where: { $0.id == wine.id }) else { return }
        wines.append(wine)
    }
    
    public func delete(_ wineId: WineId) async throws {
        if let index = wines.firstIndex(where: { $0.id == wineId }) {
            wines.remove(at: index)
        }
    }

    public func getWine(by id: WineId) async throws -> Wine? {
        wines.first { $0.id == id }
    }

    public func save(_ wine: Wine) async throws {
        guard let index = wines.firstIndex(of: wine) else {
            return
        }
        
        wines[index] = wine
    }

    public func getWines(userId: UserId, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        completion(.success(wines.filter { $0.userId == userId }))
        return FakeRegistration()
    }

    public func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let matched = self.wines.filter { $0.userId == userId && $0.type == wineType }
            completion(.success(matched))
        }
        return FakeRegistration()
    }

    public func getTopWines(userId: UserId) async throws -> [Wine] {
        let topWines = wines
            .filter { $0.userId == userId }
            .sorted { $0.rating > $1.rating }
            .prefix(3)
        return Array(topWines)
    }
    
    public func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId) async throws -> [String] {
        []
    }
}
