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
    
    init(imageRepository: WineImageRepository) {
        self.imageRepository = imageRepository
    }
    
    func createImages(wineId: UUID, photo: UIImage?) -> Data? {
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
        
        return thumbnailData
    }
    
    func createThumbnail(photo: UIImage?) -> Data? {
        guard let image = photo else {
            return nil
        }
        
        guard
            let thumbnailImage = resize(image: image, to: CGSize(width: 150, height: 150)),
            let thumbnailData = thumbnailImage.pngData()
        else {
            return nil
        }
        
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
    
    func fetchPhoto(wineId: UUID, completion: @escaping (Result<Data?>) -> ()) {
        imageRepository.fetchPhoto(wineId: wineId, completion: completion)
    }
}
