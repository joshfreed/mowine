//
//  WineWorker.swift
//  mowine
//
//  Created by Josh Freed on 11/27/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver

open class WineWorker: ObservableObject {
    let wineRepository: WineRepository
    let imageWorker: WineImageWorkerProtocol
    let session: Session
    
    public init(wineRepository: WineRepository, imageWorker: WineImageWorkerProtocol, session: Session) {
        self.wineRepository = wineRepository
        self.imageWorker = imageWorker
        self.session = session
    }

    public func createWine(from model: NewWineModel) async throws {
        try await createWine(
            type: model.wineType!,
            variety: model.wineVariety,
            name: model.name,
            rating: Double(model.rating),
            photo: model.image
        )
    }

    func createWine(type: WineType, variety: WineVariety?, name: String, rating: Double, photo: WineImage?) async throws {
        if session.currentUserId == nil {
            try await session.startAnonymous()
        }
        guard let userId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        let wine = Wine(userId: userId, type: type, name: name, rating: rating)
        wine.variety = variety
        
        _ = imageWorker.createImages(wineId: wine.id, photo: photo)

        try await wineRepository.add(wine)
    }
}
