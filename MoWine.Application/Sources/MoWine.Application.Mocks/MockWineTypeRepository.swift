//
//  MockWineTypeRepository.swift
//  MockWineTypeRepository
//
//  Created by Josh Freed on 9/7/21.
//

import XCTest
import MoWine_Application
import MoWine_Domain

class MockWineTypeRepository: WineTypeRepository {
    var types: [WineType] = []

    func getAll(completion: @escaping (Result<[WineType], Error>) -> ()) {
        completion(.success(types))
    }

    func getWineType(named name: String, completion: @escaping (Result<WineType?, Error>) -> ()) {
        let type = types.first(where: { $0.name == name })
        completion(.success(type))
    }

    func getAll() async throws -> [WineType] {
        types
    }

    func getWineType(named name: String) async throws -> WineType? {
        types.first { $0.name == name }
    }
}
