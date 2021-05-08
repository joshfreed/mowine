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
    
    func createImages(wineId: WineId, photo: WineImage?) -> Data? {
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
        imageService.putData(imageData, url: imageName, completion: putDataCompletion)
        imageService.putData(thumbnailData, url: thumbnailName, completion: putDataCompletion)
        return thumbnailData
    }
    
    private func putDataCompletion(_ result: Result<URL, Error>) {
        if case let .failure(error) = result {
            SwiftyBeaver.error("\(error)")
        }
    }

    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?, Error>) -> ()) {
        guard let userId = session.currentUserId else { return }
        let name = "\(userId)/\(wineId).png"
        SwiftyBeaver.info("Requested full res wine image. WineId: \(wineId)")
        imageService.getData(url: name, completion: completion)
    }
    
    func fetchPhoto(wine: Wine, completion: @escaping (Result<Data?, Error>) -> ()) {
        let name = "\(wine.userId)/\(wine.id).png"
        SwiftyBeaver.info("Requested full res wine image. WineId: \(wine.id)")
        imageService.getData(url: name, completion: completion)
    }
}

extension WineImageWorker: WineListThumbnailFetcher {
    func fetchThumbnail(for wineId: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        wineRepository.getWine(by: WineId(string: wineId)) { result in
            switch result {
            case .success(let wine): self.fetchThumbnail(for: wine, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    func fetchThumbnail(for wine: Wine,  completion: @escaping (Result<Data?, Error>) -> ()) {
        let name = "\(wine.userId)/\(wine.id)-thumb.png"
        SwiftyBeaver.info("Requested wine image thumbnail. WineId: \(wine.id)")
        imageService.getData(url: name, completion: completion)
    }
}
