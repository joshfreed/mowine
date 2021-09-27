//
//  GetUserCellarQuery.swift
//  GetUserCellarQuery
//
//  Created by Josh Freed on 9/14/21.
//

import Foundation

public class GetUserCellarQuery {
    private let wineTypeRepository: WineTypeRepository
    private let wineRepository: WineRepository

    public init(wineTypeRepository: WineTypeRepository, wineRepository: WineRepository) {
        self.wineTypeRepository = wineTypeRepository
        self.wineRepository = wineRepository
    }

    public func execute(userId: String) async throws -> [String] {
        let wineTypeNames = try await wineRepository.getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId(string: userId))
        let allWineTypes = try await wineTypeRepository.getAll()
        return allWineTypes.filter { wineTypeNames.contains($0.name) }.map { $0.name }
    }
}
