//
//  UpdateWineCommandHandler.swift
//  UpdateWineCommandHandler
//
//  Created by Josh Freed on 9/3/21.
//

import Foundation
import MoWine_Domain
import JFLib_Mediator

public struct UpdateWineCommand: JFMCommand {
    public let wineId: String
    public let name: String
    public let rating: Double
    public let type: String
    public var variety: String?
    public var location: String?
    public var price: String?
    public var notes: String?
    public var image: Data?
    public var pairings: [String] = []

    public init(wineId: String, name: String, rating: Double, type: String) {
        self.wineId = wineId
        self.name = name
        self.rating = rating
        self.type = type
    }
}

class UpdateWineCommandHandler: BaseCommandHandler<UpdateWineCommand> {
    let wineRepository: WineRepository
    let wineTypeRepository: WineTypeRepository
    let createWineImages: CreateWineImagesCommandHandler

    init(wineRepository: WineRepository, wineTypeRepository: WineTypeRepository, createWineImages: CreateWineImagesCommandHandler) {
        self.wineRepository = wineRepository
        self.wineTypeRepository = wineTypeRepository
        self.createWineImages = createWineImages
    }

    override func handle(command: UpdateWineCommand) async throws {
        let wineId = WineId(string: command.wineId)

        guard let wine = try await wineRepository.getWine(by: wineId) else {
            throw UpdateWineError.wineNotFound
        }

        wine.name = command.name
        wine.rating = command.rating
        wine.location = command.location
        wine.notes = command.notes
        wine.price = command.price
        wine.pairings = command.pairings

        guard let newType = try await wineTypeRepository.getWineType(named: command.type) else {
            throw UpdateWineError.invalidWineType
        }

        wine.type = newType

        if let varietyName = command.variety, let variety = wine.type.getVariety(named: varietyName) {
            wine.variety = variety
        } else {
            wine.variety = nil
        }

        try await wineRepository.save(wine)

        if let imageData = command.image {
            _ = try await createWineImages.handle(.init(wineId: wine.id.asString, data: imageData))
            // NotificationCenter.default.post(name: .wineUpdated, object: nil, userInfo: ["wineId": wineId.asString, "thumbnail": thumbnail])
        }
    }
}

enum UpdateWineError: Error {
    case wineNotFound
    case invalidWineType
}
