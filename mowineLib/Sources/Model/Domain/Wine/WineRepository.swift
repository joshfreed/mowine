//
//  WineRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation

public protocol WineRepository {
    func add(_ wine: Wine) async throws
    func save(_ wine: Wine) async throws
    func delete(_ wineId: WineId) async throws
    func getWine(by id: WineId) async throws -> Wine?
    func getWines(userId: UserId, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration
    func getTopWines(userId: UserId) async throws -> [Wine]
    func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId) async throws -> [String]
}

public enum WineRepositoryError: Error {
    case notFound
}
