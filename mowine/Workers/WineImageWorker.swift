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

    func fetchPhoto(wineId: WineId) async throws -> Data? {
        guard let userId = session.currentUserId else { return nil }
        let name = "\(userId)/\(wineId).png"
        SwiftyBeaver.info("Requested full res wine image. WineId: \(wineId)")
        return try await imageService.getData(url: name)
    }

    func fetchPhoto(wine: Wine) async throws -> Data? {
        let name = "\(wine.userId)/\(wine.id).png"
        SwiftyBeaver.info("Requested full res wine image. WineId: \(wine.id)")
        return try await imageService.getData(url: name)
    }
}

extension WineImageWorker: WineListThumbnailFetcher {
    func fetchThumbnail(for wineId: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        Task {
            do {
                guard let wine = try await wineRepository.getWine(by: WineId(string: wineId)) else {
                    throw WineRepositoryError.notFound
                }
                
                fetchThumbnail(for: wine, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchThumbnail(for wine: Wine,  completion: @escaping (Result<Data?, Error>) -> ()) {
        let name = "\(wine.userId)/\(wine.id)-thumb.png"
        SwiftyBeaver.info("Requested wine image thumbnail. WineId: \(wine.id)")
        Task {
            do {
                let data = try await imageService.getData(url: name)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
