//
//  GetMyWines.swift
//  
//
//  Created by Josh Freed on 10/27/21.
//

import Foundation
import JFLib_Mediator
import MoWine_Domain

public struct GetMyWines: JFMQuery {
    public init() {}
}

public struct GetMyWinesResponse {
    public let wines: [Wine]

    public struct Wine {
        public let id: String
        public let name: String
        public let rating: Int
        public let typeName: String
        public let varietyName: String?
    }
}

public class GetMyWinesHandler: BaseQueryHandler<GetMyWines, GetMyWinesResponse> {
    private let session: Session
    private let repository: WineRepository

    public init(session: Session, repository: WineRepository) {
        self.session = session
        self.repository = repository
    }

    override public func handle(query: GetMyWines) async throws -> GetMyWinesResponse {
        guard let currentUserId = session.currentUserId else {
            return .init(wines: [])
        }

        let wineModels = try await repository.getWines(userId: currentUserId)

        let responseWines: [GetMyWinesResponse.Wine] = wineModels.map {
            .init(id: $0.id.asString, name: $0.name, rating: Int($0.rating), typeName: $0.type.name, varietyName: $0.variety?.name)
        }

        return .init(wines: responseWines)
    }
}
