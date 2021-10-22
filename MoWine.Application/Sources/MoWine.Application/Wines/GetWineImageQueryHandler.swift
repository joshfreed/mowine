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

public class GetWineImageQueryHandler: BaseQueryHandler<GetWineImageQuery, Data?> {
    let wineImageStorage: WineImageStorage

    public init(wineImageStorage: WineImageStorage) {
        self.wineImageStorage = wineImageStorage
    }

    public override func handle(query: GetWineImageQuery) async throws -> Data? {
        let wineId = WineId(string: query.wineId)

        do {
            return try await wineImageStorage.getImage(wineId: wineId, size: .full)
        } catch WineImageStorageErrors.imageNotFound {
            return nil
        }
    }
}
