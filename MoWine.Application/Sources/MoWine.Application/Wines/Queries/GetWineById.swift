//
//  GetWineByIdQueryHandler.swift
//  GetWineByIdQueryHandler
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation
import MoWine_Domain
import JFLib_Mediator

public struct GetWineByIdQuery: JFMQuery {
    public let wineId: String

    public init(wineId: String) {
        self.wineId = wineId
    }
}

class GetWineByIdQueryHandler: BaseQueryHandler<GetWineByIdQuery, GetWineByIdQueryResponse?>  {
    private let wineRepository: WineRepository

    init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    override func handle(query: GetWineByIdQuery) async throws -> GetWineByIdQueryResponse? {
        guard let wine = try await wineRepository.getWine(by: WineId(string: query.wineId)) else {
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
