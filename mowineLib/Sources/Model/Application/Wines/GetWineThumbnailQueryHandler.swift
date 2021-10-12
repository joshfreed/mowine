//
//  GetWineThumbnailQueryHandler.swift
//
//
//  Created by Josh Freed on 10/12/21.
//

import Foundation

public class GetWineThumbnailQueryHandler {
    let wineImageStorage: WineImageStorage

    public init(wineImageStorage: WineImageStorage) {
        self.wineImageStorage = wineImageStorage
    }

    public func handle(wineId: String) async throws -> Data? {
        let wineId = WineId(string: wineId)

        do {
            return try await wineImageStorage.getImage(wineId: wineId, size: .thumbnail)
        } catch WineImageStorageErrors.imageNotFound {
            return nil
        }
    }
}
