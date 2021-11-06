//
//  GetWineImageQueryHandler.swift
//  GetWineImageQueryHandler
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation
import MoWine_Domain
import JFLib_Mediator

public struct GetWineImageQuery: JFMQuery {
    public let wineId: String

    public init(wineId: String) {
        self.wineId = wineId
    }
}

class GetWineImageQueryHandler: BaseQueryHandler<GetWineImageQuery, Data?> {
    private let wineImageStorage: WineImageStorage

    init(wineImageStorage: WineImageStorage) {
        self.wineImageStorage = wineImageStorage
    }

    override func handle(query: GetWineImageQuery) async throws -> Data? {
        let wineId = WineId(string: query.wineId)

        do {
            return try await wineImageStorage.getImage(wineId: wineId, size: .full)
        } catch WineImageStorageErrors.imageNotFound {
            return nil
        }
    }
}
