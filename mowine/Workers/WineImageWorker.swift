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
        guard
            let downsizedImage = image.resize(to: CGSize(width: 400, height: 400)),
            let imageData = downsizedImage.pngData(),
            let thumbnailImage = image.resize(to: CGSize(width: 150, height: 150)),
            let thumbnailData = thumbnailImage.pngData()
        else {
            return nil
        }

        let imageName = "\(userId)/\(wineId).png"
        let thumbnailName = "\(userId)/\(wineId)-thumb.png"
        _ = try await imageService.putData(imageData, url: imageName)
        _ = try await imageService.putData(thumbnailData, url: thumbnailName)
        return thumbnailData
    }
}
