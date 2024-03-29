//
//  CreateWineCommandHandler.swift
//  mowine
//
//  Created by Josh Freed on 11/27/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib_Mediator
import MoWine_Domain

public struct CreateWineCommand: JFMCommand {
    public var wineType: String
    public var wineVariety: String?
    public var image: Data?
    public var name: String
    public var rating: Int

    public init(name: String, rating: Int, wineType: String, wineVariety: String? = nil, image: Data? = nil) {
        self.name = name
        self.rating = rating
        self.wineType = wineType
        self.wineVariety = wineVariety
        self.image = image
    }
}

class CreateWineCommandHandler: BaseCommandHandler<CreateWineCommand> {
    private let wineRepository: WineRepository
    private let session: Session
    private let createWineImages: CreateWineImagesCommandHandler
    private let wineTypeRepository: WineTypeRepository

    init(
        wineRepository: WineRepository,
        session: Session,
        createWineImages: CreateWineImagesCommandHandler,
        wineTypeRepository: WineTypeRepository
    ) {
        self.wineRepository = wineRepository
        self.session = session
        self.createWineImages = createWineImages
        self.wineTypeRepository = wineTypeRepository
    }

    override func handle(command: CreateWineCommand) async throws {
        guard let wineType = try await wineTypeRepository.getWineType(named: command.wineType) else {
            throw ApplicationErrors.wineTypeNotFound
        }

        if session.currentUserId == nil {
            try await session.startAnonymous()
        }
        
        guard let userId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        let wine = Wine(userId: userId, type: wineType, name: command.name, rating: Double(command.rating))

        if let wineVariety = command.wineVariety {
            wine.variety = wineType.getVariety(named: wineVariety)
        }

        try await wineRepository.add(wine)

        if let imageData = command.image {
            _ = try await createWineImages.handle(.init(wineId: wine.id.asString, data: imageData))
        }
    }
}
