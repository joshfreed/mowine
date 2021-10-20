//
//  AssetWineImageStorage.swift
//  mowine
//
//  Created by Josh Freed on 10/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import UIKit
import MoWine_Application
import MoWine_Domain

class AssetWineImageStorage: WineImageStorage {
    private let wineRepository: WineRepository

    init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    func putImage(wineId: WineId, size: WineImageSize, data: Data) async throws {
        fatalError("Cannot store to asset catalog")
    }

    func getImage(wineId: WineId, size: WineImageSize) async throws -> Data {
        guard let wine = try await wineRepository.getWine(by: wineId) else {
            throw WineImageStorageErrors.imageNotFound
        }

        var imageName: String = "\(wine.userId)_\(wine.id)"
        switch size {
        case .thumbnail: imageName += "_Thumb"
        case .full: imageName += "_Full"
        }

        guard let image = UIImage(named: imageName), let data = image.pngData() else {
            throw WineImageStorageErrors.imageNotFound
        }

        return data
    }
}
