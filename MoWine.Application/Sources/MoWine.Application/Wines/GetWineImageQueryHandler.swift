//
//  GetWineImageQueryHandler.swift
//  GetWineImageQueryHandler
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation
import MoWine_Domain

public class GetWineImageQueryHandler {
    let wineImageStorage: WineImageStorage

    public init(wineImageStorage: WineImageStorage) {
        self.wineImageStorage = wineImageStorage
    }

    public func handle(wineId: String) async throws -> Data? {
        let wineId = WineId(string: wineId)

        do {
            return try await wineImageStorage.getImage(wineId: wineId, size: .full)
        } catch WineImageStorageErrors.imageNotFound {
            return nil
        }
    }
}
