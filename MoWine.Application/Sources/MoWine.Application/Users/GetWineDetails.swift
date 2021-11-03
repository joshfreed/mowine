//
//  GetWineDetails.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Domain
import JFLib_Mediator

public struct GetWineDetails: JFMQuery {
    public let wineId: String

    public init(wineId: String) {
        self.wineId = wineId
    }
}

public struct GetWineDetailsResponse {
    public let id: String
    public let name: String
    public let rating: Int
    public let varietyName: String
    public let typeName: String
    public let price: String
    public let location: String

    public init(id: String, name: String, rating: Int, varietyName: String, typeName: String, price: String, location: String) {
        self.id = id
        self.name = name
        self.rating = rating
        self.varietyName = varietyName
        self.typeName = typeName
        self.price = price
        self.location = location
    }
}

public enum GetWineDetailsErrors: Error {
    case wineNotFound
}

class GetWineDetailsHandler: BaseQueryHandler<GetWineDetails, GetWineDetailsResponse> {
    private let wineRepository: WineRepository

    init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    override func handle(query: GetWineDetails) async throws -> GetWineDetailsResponse {
        guard let wine = try await wineRepository.getWine(by: WineId(string: query.wineId)) else {
            throw GetWineDetailsErrors.wineNotFound
        }

        return .init(
            id: wine.id.asString,
            name: wine.name,
            rating: Int(wine.rating),
            varietyName: wine.varietyName,
            typeName: wine.type.name,
            price: wine.price ?? "",
            location: wine.location ?? ""
        )
    }
}
