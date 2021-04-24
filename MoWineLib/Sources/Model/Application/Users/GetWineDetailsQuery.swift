//
//  GetWineDetailsQuery.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver

public class GetWineDetailsQuery: ObservableObject {
    @Published public var wine: WineDetails?

    private let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    public func execute(wineId: String) {
        wineRepository.getWine(by: WineId(string: wineId)) { result in
            switch result {
            case .success(let wine):
                self.wine = .init(
                    id: wine.id.asString,
                    name: wine.name,
                    rating: Int(wine.rating),
                    varietyName: wine.varietyName,
                    typeName: wine.type.name,
                    price: wine.price ?? "",
                    location: wine.location ?? ""
                )
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
            }
        }
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

        public init(id: String, name: String, rating: Int, varietyName: String, typeName: String, price: String, location: String) {
            self.id = id
            self.name = name
            self.rating = rating
            self.varietyName = varietyName
            self.typeName = typeName
            self.price = price
            self.location = location
        }
    }
}
