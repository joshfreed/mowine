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
    let session: Session
    
    init(wineRepository: WineRepository, imageWorker: WineImageWorker, session: Session) {
        self.wineRepository = wineRepository
        self.imageWorker = imageWorker
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
        
        _ = imageWorker.createImages(wineId: wine.id, photo: photo)
        
        wineRepository.add(wine, completion: completion)
    }

    func updateRating(of wine: Wine, to rating: Double) {
        wine.rating = rating
        // save in repo
    }
    
    func delete(wine: Wine) {
        wineRepository.delete(wine, completion: { _ in })
    }
}
