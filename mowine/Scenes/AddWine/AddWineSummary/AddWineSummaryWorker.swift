//
//  AddWineSummaryWorker.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import UIKit
import JFLib

class AddWineSummaryWorker {
    let wineRepository: WineRepository
    let imageWorker: WineImageWorker
    let imageRepository: WineImageRepository
    let session: Session
    
    init(
        wineRepository: WineRepository,
        imageWorker: WineImageWorker,
        imageRepository: WineImageRepository,
        session: Session
    ) {
        self.wineRepository = wineRepository
        self.imageWorker = imageWorker
        self.imageRepository = imageRepository
        self.session = session
    }
    
    func createWine(
        type: WineType,
        variety: WineVariety?,
        name: String,
        rating: Double,
        photo: UIImage?,
        completion: @escaping (Result<Wine>) -> ()
    ) {
        guard let userId = session.currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }
        
        let wine = Wine(userId: userId, type: type, name: name, rating: rating)
        wine.variety = variety
        wine.thumbnail = self.createThumbnail(photo: photo)        
        wineRepository.add(wine, completion: completion)
    }
    
    private func createThumbnail(photo: UIImage?) -> Data? {
        guard let image = photo else {
            return nil
        }
        
        guard
            let thumbnailImage = imageWorker.resize(image: image, to: CGSize(width: 150, height: 150)),
            let thumbnailData = imageWorker.toPNG(image: thumbnailImage)
        else {
                return nil
        }
        
        return thumbnailData
    }
    
    func createImages(wineId: UUID, photo: UIImage?) -> Data? {
        guard let image = photo else {
            return nil
        }
        
        guard
            let downsizedImage = imageWorker.resize(image: image, to: CGSize(width: 400, height: 400)),
            let imageData = imageWorker.toPNG(image: downsizedImage),
            let thumbnailImage = imageWorker.resize(image: image, to: CGSize(width: 150, height: 150)),
            let thumbnailData = imageWorker.toPNG(image: thumbnailImage)
        else {
            return nil
        }
        
        imageRepository.store(wineId: wineId, image: imageData, thumbnail: thumbnailData)
        
        return thumbnailData
    }
    
    func updateRating(of wine: Wine, to rating: Double) {
        wine.rating = rating
        // save in repo
    }
    
    func delete(wine: Wine) {
        wineRepository.delete(wine, completion: { _ in })
    }
}
