//
//  GetWineDetailsQuery.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import FirebaseCrashlytics

class GetWineDetailsQuery: ObservableObject {
    @Published var wine: WineDetails?

    private let wineRepository: WineRepository

    init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    func execute(wineId: String) {
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
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}

extension GetWineDetailsQuery {
    struct WineDetails {
        let id: String
        let name: String
        let rating: Int
        let varietyName: String
        let typeName: String
        let price: String
        let location: String
    }
}
