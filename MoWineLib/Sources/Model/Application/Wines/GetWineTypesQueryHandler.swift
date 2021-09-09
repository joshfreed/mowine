//
//  GetWineTypesQueryHandler.swift
//  GetWineTypesQueryHandler
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation

public class GetWineTypesQueryHandler {
    let wineTypeRepository: WineTypeRepository

    public init(wineTypeRepository: WineTypeRepository) {
        self.wineTypeRepository = wineTypeRepository
    }

    public func handle() async throws -> [WineType] {
        try await wineTypeRepository.getAll()
    }
}
