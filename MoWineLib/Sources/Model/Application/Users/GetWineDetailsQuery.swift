//
//  GetWineDetailsQuery.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation

public class GetWineDetailsQuery: ObservableObject {
    @Published public var wine: WineDetails?

    private let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    @MainActor
    public func execute(wineId: String) async throws {
        guard let wine = try await wineRepository.getWine(by: WineId(string: wineId)) else {
            throw Errors.wineNotFound
        }

        self.wine = .init(
            id: wine.id.asString,
            name: wine.name,
            rating: Int(wine.rating),
            varietyName: wine.varietyName,
            typeName: wine.type.name,
            price: wine.price ?? "",
            location: wine.location ?? "",
            thumbnailPath: "\(wine.userId)/\(wine.id).png"
        )
    }
}

extension GetWineDetailsQuery {
    public struct WineDetails {
        public let id: String
        public let name: String
        public let rating: Int
        public let varietyName: String
        public let typeName: String
        public let price: String
        public let location: String
        public let thumbnailPath: String

        public init(id: String, name: String, rating: Int, varietyName: String, typeName: String, price: String, location: String, thumbnailPath: String) {
            self.id = id
            self.name = name
            self.rating = rating
            self.varietyName = varietyName
            self.typeName = typeName
            self.price = price
            self.location = location
            self.thumbnailPath = thumbnailPath
        }
    }

    public enum Errors: Error {
        case wineNotFound
    }
}
