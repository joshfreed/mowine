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

public struct GetTopWinesResponse {
    public let topWines: [TopWine]

    public init(topWines: [GetTopWinesResponse.TopWine]) {
        self.topWines = topWines
    }

    public struct TopWine: Identifiable, Equatable {
        public let id: String
        public let name: String
        public let rating: Int
        public let type: String

        public init(id: String, name: String, rating: Int, type: String) {
            self.id = id
            self.name = name
            self.rating = rating
            self.type = type
        }
    }
}

public class GetTopWinesQueryHandler: BaseQueryHandler<GetTopWinesQuery, GetTopWinesResponse> {
    private let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    public override func handle(query: GetTopWinesQuery) async throws -> GetTopWinesResponse {
        let userId = UserId(string: query.userId)
        let topWines = try await wineRepository.getTopWines(userId: userId)
        let mappedWines = topWines.map {
            GetTopWinesResponse.TopWine(id: $0.id.asString, name: $0.name, rating: Int($0.rating), type: $0.type.name)
        }
        return GetTopWinesResponse(topWines: mappedWines)
    }
}
