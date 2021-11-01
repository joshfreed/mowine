//
//  GetWinesByType.swift
//  
//
//  Created by Josh Freed on 10/31/21.
//

import Foundation
import JFLib_Mediator
import MoWine_Domain

public struct GetWinesByTypeQuery: JFMQuery {
    public let userId: String
    public let type: String

    public init(userId: String, type: String) {
        self.userId = userId
        self.type = type
    }
}

public struct GetWinesByTypeResponse {
    public let wines: [Wine]

    public init(wines: [GetWinesByTypeResponse.Wine]) {
        self.wines = wines
    }

    public struct Wine: Identifiable, Equatable {
        public let id: String
        public let name: String
        public let rating: Int
        public let type: String
    }
}

public class GetWinesByTypeQueryHandler: BaseQueryHandler<GetWinesByTypeQuery, GetWinesByTypeResponse> {
    private let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    public override func handle(query: GetWinesByTypeQuery) async throws -> GetWinesByTypeResponse {
        let userId = UserId(string: query.userId)
        let wineType = WineType(name: query.type) // Hmm, get from repository?

        let wines = try await wineRepository
            .getWines(userId: userId, wineType: wineType)
            .map {
                GetWinesByTypeResponse.Wine(id: $0.id.asString, name: $0.name, rating: Int($0.rating), type: $0.type.name)
            }

        return GetWinesByTypeResponse(wines: wines)
    }
}
