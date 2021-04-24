//
//  WineWorker.swift
//  mowine
//
//  Created by Josh Freed on 11/27/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
import Combine
import SwiftyBeaver
import Model

class WineWorker: ObservableObject {
    let wineRepository: WineRepository
    let imageWorker: WineImageWorkerProtocol
    let session: Session
    
    init(wineRepository: WineRepository, imageWorker: WineImageWorkerProtocol, session: Session) {
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
        completion: @escaping (Result<Wine, Error>) -> ()
    ) {
        guard let userId = session.currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }
        
        let wine = Wine(userId: userId, type: type, name: name, rating: rating)
        wine.variety = variety
        
        _ = imageWorker.createImages(wineId: wine.id, photo: photo)
        
        wineRepository.add(wine) { result in
            switch result {
            case .success(let wine):
                NotificationCenter.default.post(name: .wineAdded, object: nil, userInfo: ["wine": wine])
                completion(.success(wine))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
