//
//  CreateWineCommandHandler.swift
//  mowine
//
//  Created by Josh Freed on 11/27/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver

public struct CreateWineCommand {
    public var wineType: WineType
    public var wineVariety: WineVariety?
    public var image: WineImage?
    public var name: String
    public var rating: Int

    public init(name: String, rating: Int, wineType: WineType, wineVariety: WineVariety? = nil, image: WineImage? = nil) {
        self.name = name
        self.rating = rating
        self.wineType = wineType
        self.wineVariety = wineVariety
        self.image = image
    }
}

open class CreateWineCommandHandler {
    let wineRepository: WineRepository
    let imageWorker: WineImageWorkerProtocol
    let session: Session
    
    public init(wineRepository: WineRepository, imageWorker: WineImageWorkerProtocol, session: Session) {
        SwiftyBeaver.verbose("CreateWineCommandHandler::init")
        self.wineRepository = wineRepository
        self.imageWorker = imageWorker
        self.session = session
    }

    deinit {
        SwiftyBeaver.verbose("CreateWineCommandHandler::deinit")
    }

    public func createWine(_ command: CreateWineCommand) async throws {
        if session.currentUserId == nil {
            try await session.startAnonymous()
        }
        
        guard let userId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        let wine = Wine(userId: userId, type: command.wineType, name: command.name, rating: Double(command.rating))
        wine.variety = command.wineVariety

        _ = try await imageWorker.createImages(wineId: wine.id, photo: command.image)

        try await wineRepository.add(wine)
    }
}
