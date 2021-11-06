//
//  GetMyWines.swift
//  
//
//  Created by Josh Freed on 10/27/21.
//

import Foundation
import Combine
import SwiftyBeaver
import MoWine_Domain

public class GetMyWinesHandler {
    private let session: Session
    private let repository: WineRepository

    public init(session: Session, repository: WineRepository) {
        self.session = session
        self.repository = repository
    }

    public func subscribe() -> AnyPublisher<GetMyWinesResponse, Error> {
        SwiftyBeaver.verbose("subscribe: \(String(describing: session.currentUserId))")

        guard let userId = session.currentUserId else {
            return Just(GetMyWinesResponse(wines: [])).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        return repository
            .getWines(userId: userId)
            .map { wines -> [GetMyWinesResponse.Wine] in
                wines.map {
                    .init(id: $0.id.asString, name: $0.name, rating: Int($0.rating), typeName: $0.type.name, varietyName: $0.variety?.name)
                }
            }
            .map { wines in
                GetMyWinesResponse(wines: wines)
            }
            .eraseToAnyPublisher()
    }
}

public struct GetMyWinesResponse {
    public let wines: [Wine]

    public init(wines: [Wine]) {
        self.wines = wines
    }

    public struct Wine {
        public let id: String
        public let name: String
        public let rating: Int
        public let typeName: String
        public let varietyName: String?
    }
}
