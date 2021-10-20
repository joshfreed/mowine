//
//  GetWineByIdQueryHandler.swift
//  GetWineByIdQueryHandler
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation
import MoWine_Domain

public class GetWineByIdQueryHandler {
    private let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    public func handle(wineId: String) async throws -> GetWineByIdQueryResponse? {
        guard let wine = try await wineRepository.getWine(by: WineId(string: wineId)) else {
            return nil
        }

        return GetWineByIdQueryResponse(
            id: wine.id.asString,
            name: wine.name,
            rating: Int(wine.rating),
            typeId: wine.type.id,
            typeName: wine.type.name,
            varietyId: wine.variety?.id,
            varietyName: wine.variety?.name,
            location: wine.location ?? "",
            price: wine.price ?? "",
            notes: wine.notes ?? "",
            pairings: wine.pairings
        )
    }
}

public struct GetWineByIdQueryResponse {
    public let id: String
    public let name: String
    public let rating: Int
    public let typeId: Int
    public let typeName: String
    public let varietyId: Int?
    public let varietyName: String?
    public let location: String
    public let price: String
    public let notes: String
    public let pairings: [String]
}
