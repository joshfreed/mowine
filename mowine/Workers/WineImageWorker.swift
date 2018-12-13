//
//  WineImageWorker.swift
//  mowine
//
//  Created by Josh Freed on 11/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import JFLib

class WineImageWorker {
    let imageRepository: WineImageRepository
    let thumbnailCache = NSCache<NSString, NSData>()
    let photoCache = NSCache<NSString, NSData>()
    let wineRepository: WineRepository
    
    init(imageRepository: WineImageRepository, wineRepository: WineRepository) {
        self.imageRepository = imageRepository
        self.wineRepository = wineRepository
    }
    
    func createImages(wineId: WineId, photo: UIImage?) -> Data? {
        guard let image = photo else {
            return nil
        }
        
        guard
            let downsizedImage = resize(image: image, to: CGSize(width: 400, height: 400)),
            let imageData = downsizedImage.pngData(),
            let thumbnailImage = resize(image: image, to: CGSize(width: 150, height: 150)),
            let thumbnailData = thumbnailImage.pngData()
        else {
            return nil
        }
        
        imageRepository.store(wineId: wineId, image: imageData, thumbnail: thumbnailData)
        
        thumbnailCache.setObject(thumbnailData as NSData, forKey: wineId.uuidString as NSString)
        photoCache.setObject(imageData as NSData, forKey: wineId.uuidString as NSString)
        
        return thumbnailData
    }

    func resize(image: UIImage, to desiredSize: CGSize) -> UIImage? {
        let scale = min(desiredSize.width / image.size.width, desiredSize.height / image.size.height)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        var newImage: UIImage?
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?>) -> ()) {
        if let cachedImage = photoCache.object(forKey: wineId.uuidString as NSString) {
            completion(.success(cachedImage as Data))
            return
        }
        
        imageRepository.fetchPhoto(wineId: wineId) { result in
            if case let .success(data) = result, let nsdata = data as NSData? {
                self.photoCache.setObject(nsdata, forKey: wineId.uuidString as NSString)
            }
            completion(result)
        }
    }
    
    func fetchThumbnail(for wine: Wine,  completion: @escaping (Result<Data?>) -> ()) {
        if let cachedImage = thumbnailCache.object(forKey: wine.id.uuidString as NSString) {
            completion(.success(cachedImage as Data))
            return
        }
        
        imageRepository.fetchThumbnail(wineId: wine.id, userId: wine.userId) { result in
            if case let .success(data) = result, let nsdata = data as NSData? {
                self.thumbnailCache.setObject(nsdata, forKey: wine.id.uuidString as NSString)
            }
            completion(result)
        }
    }
}


extension WineImageWorker: WineListThumbnailFetcher {
    func fetchThumbnail(for wineId: String, completion: @escaping (Result<Data?>) -> ()) {
        if let cachedImage = thumbnailCache.object(forKey: wineId as NSString) {
            completion(.success(cachedImage as Data))
            return
        }
        
        wineRepository.getWine(by: WineId(string: wineId)) { result in
            switch result {
            case .success(let wine): self.fetchThumbnail(for: wine, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
