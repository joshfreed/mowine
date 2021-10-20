//
//  GetWineTypesQueryHandler.swift
//  GetWineTypesQueryHandler
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation
import MoWine_Domain

public class GetWineTypesQueryHandler {
    private let wineTypeRepository: WineTypeRepository

    public init(wineTypeRepository: WineTypeRepository) {
        self.wineTypeRepository = wineTypeRepository
    }

    public func handle() async throws -> GetWineTypesQueryResponse {
        let wineTypes = try await wineTypeRepository.getAll()
        return GetWineTypesQueryResponse(wineTypes: wineTypes.map(toResponseType))
    }

    private func toResponseType(_ type: WineType) -> GetWineTypesQueryResponse.WineType {
        .init(id: type.id, name: type.name, varieties: type.varieties.map(toResponseVariety))
    }

    private func toResponseVariety(_ variety: WineVariety) -> GetWineTypesQueryResponse.WineVariety {
        .init(id: variety.id, name: variety.name)
    }
}

public struct GetWineTypesQueryResponse {
    public let wineTypes: [WineType]

    public struct WineType {
        public let id: Int
        public let name: String
        public let varieties: [WineVariety]
    }

    public struct WineVariety {
        public let id: Int
        public let name: String
    }
}
