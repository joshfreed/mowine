//
//  GetTopWines.swift
//  mowine
//
//  Created by Josh Freed on 3/7/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Domain
import JFLib_Mediator

public struct GetTopWinesQuery: JFMQuery {
    public let userId: String

    public init(userId: String) {
        self.userId = userId
    }
}

public struct GetTopWinesQueryResponse {
    public let topWines: [TopWine]

    public init(topWines: [GetTopWinesQueryResponse.TopWine]) {
        self.topWines = topWines
    }

    public struct TopWine: Identifiable, Equatable {
        public let id: String
        public let name: String
        public let rating: Int
        public let type: String
        public let userId: String
    }
}

public class GetTopWinesQueryHandler: BaseQueryHandler<GetTopWinesQuery, GetTopWinesQueryResponse> {
    private let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    public override func handle(query: GetTopWinesQuery) async throws -> GetTopWinesQueryResponse {
        let userId = UserId(string: query.userId)
        let topWines = try await wineRepository.getTopWines(userId: userId)
        let mappedWines = topWines.map {
            GetTopWinesQueryResponse.TopWine(id: $0.id.asString, name: $0.name, rating: Int($0.rating), type: $0.type.name, userId: $0.userId.asString)
        }
        return GetTopWinesQueryResponse(topWines: mappedWines)
    }
}
