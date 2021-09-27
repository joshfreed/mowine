//
//  UpdateWineCommandHandler.swift
//  UpdateWineCommandHandler
//
//  Created by Josh Freed on 9/3/21.
//

import Foundation

public struct UpdateWineCommand {
    public let wineId: String
    public let name: String
    public let rating: Double
    public let type: String
    public var variety: String?
    public var location: String?
    public var price: String?
    public var notes: String?
    public var image: WineImage?
    public var pairings: [String] = []

    public init(wineId: String, name: String, rating: Double, type: String) {
        self.wineId = wineId
        self.name = name
        self.rating = rating
        self.type = type
    }
}

public class UpdateWineCommandHandler {
    let wineRepository: WineRepository
    let imageWorker: WineImageWorkerProtocol
    let wineTypeRepository: WineTypeRepository

    public init(wineRepository: WineRepository, imageWorker: WineImageWorkerProtocol, wineTypeRepository: WineTypeRepository) {
        self.wineRepository = wineRepository
        self.imageWorker = imageWorker
        self.wineTypeRepository = wineTypeRepository
    }

    public func handle(_ command: UpdateWineCommand) async throws {
        let wineId = WineId(string: command.wineId)

        if let thumbnail = imageWorker.createImages(wineId: wineId, photo: command.image) {
            NotificationCenter.default.post(name: .wineUpdated, object: nil, userInfo: ["wineId": wineId.asString, "thumbnail": thumbnail])
        }

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
    }
}

enum UpdateWineError: Error {
    case wineNotFound
    case invalidWineType
}
