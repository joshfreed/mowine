//
//  GetUserCellary.swift
//  GetUserCellarQuery
//
//  Created by Josh Freed on 9/14/21.
//

import Foundation
import JFLib_Mediator
import MoWine_Domain

public struct GetUserCellar: JFMQuery {
    public let userId: String
    
    public init(userId: String) {
        self.userId = userId
    }
}

public struct GetUserCellarResponse {
    public let types: [String]

    public init(types: [String]) {
        self.types = types
    }
}

class GetUserCellarHandler: BaseQueryHandler<GetUserCellar, GetUserCellarResponse> {
    private let wineRepository: WineRepository

    init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    override func handle(query: GetUserCellar) async throws -> GetUserCellarResponse {
        let userId = UserId(string: query.userId)
        let wineTypeNames = try await wineRepository.getWineTypeNamesWithAtLeastOneWineLogged(userId: userId)
        return GetUserCellarResponse(types: wineTypeNames)
    }
}
