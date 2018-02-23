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
    
    init(wineRepository: WineRepository, imageWorker: WineImageWorker) {
        self.wineRepository = wineRepository
        self.imageWorker = imageWorker
    }
    
    func createWine(type: WineType, variety: WineVariety?, photo: UIImage?, name: String, rating: Double, completion: @escaping (Result<Wine>) -> ()) {
        let wine = Wine(type: type, name: name, rating: rating)
        wine.variety = variety
        
        if let image = photo {
            wine.photo = imageWorker.convertToPNGData(image: image) as Data?
            wine.thumbnail = imageWorker.createThumbnail(from: image) as Data?
        }
        
        wineRepository.save(wine, completion: completion)
    }
    
    func updateRating(of wine: Wine, to rating: Double) {
        wine.rating = rating
        // save in repo
    }
    
    func delete(wine: Wine) {
        wineRepository.delete(wine, completion: { _ in })
    }
}
