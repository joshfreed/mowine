//
//  GetTopWinesQuery.swift
//  mowine
//
//  Created by Josh Freed on 3/7/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver

public class GetTopWinesQuery {
    private let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    public func execute(userId: String) async throws -> [TopWine] {
        let topWines = try await wineRepository.getTopWines(userId: UserId(string: userId))
        let mappedWines = topWines.map {
            TopWine(id: $0.id.asString, name: $0.name, rating: Int($0.rating), type: $0.type.name, userId: $0.userId.asString)
        }
        return mappedWines
    }
}

extension GetTopWinesQuery {
    public struct TopWine {
        public let id: String
        public let name: String
        public let rating: Int
        public let type: String
        public let userId: String
    }
}
