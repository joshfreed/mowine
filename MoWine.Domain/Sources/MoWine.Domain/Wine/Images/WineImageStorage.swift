//
//  WineImageStorage.swift
//  
//
//  Created by Josh Freed on 10/1/21.
//

import Foundation

public protocol WineImageStorage {
    func putImage(wineId: WineId, size: WineImageSize, data: Data) async throws
    func getImage(wineId: WineId, size: WineImageSize) async throws -> Data
}

public enum WineImageStorageErrors: Error {
    case imageNotFound
}
