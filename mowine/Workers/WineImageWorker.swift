//
//  WineImageWorker.swift
//  mowine
//
//  Created by Josh Freed on 11/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftyBeaver
import Model

class WineImageWorker<DataServiceType: DataServiceProtocol>: WineImageWorkerProtocol
where
    DataServiceType.GetDataUrl == String,
    DataServiceType.PutDataUrl == String
{
    let imageService: DataServiceType
    let session: Session
    let wineRepository: WineRepository

    init(session: Session, wineRepository: WineRepository, imageService: DataServiceType) {
        self.imageService = imageService
        self.session = session
        self.wineRepository = wineRepository
    }
    
    func createImages(wineId: WineId, photo: WineImage?) async throws -> Data? {
        guard let image = photo else {
            return nil
        }

        guard let userId = session.currentUserId else {
            return nil
        }

        _ = try await generateImage(named: WineFullImageName(userId: userId, wineId: wineId), size: .init(width: 400, height: 400), from: image)

        let thumbnailData = try await generateImage(named: WineThumbnailName(userId: userId, wineId: wineId), size: .init(width: 150, height: 150), from: image)

        return thumbnailData
    }

    private func generateImage(named imageName: WineImageName, size: CGSize, from wineImage: WineImage) async throws -> Data? {
        guard
            let downsizedImage = wineImage.resize(to: size),
            let imageData = downsizedImage.pngData()
        else {
            return nil
        }

        _ = try await imageService.putData(imageData, url: imageName.name)

        return imageData
    }
}
