//
//  GetUserWinesByTypeQuery.swift
//  mowine
//
//  Created by Josh Freed on 3/21/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import MoWine_Domain

public struct WineItemViewModel: Identifiable {
    public var id: String
    public var name: String
    public var rating: Int
    public var type: String

    public init(id: String, name: String, rating: Int, type: String) {
        self.id = id
        self.name = name
        self.rating = rating
        self.type = type
    }

    public static func toDto(_ wine: Wine) -> WineItemViewModel {
        .init(id: wine.id.asString, name: wine.name, rating: Int(wine.rating), type: wine.type.name)
    }
}

public class GetUserWinesByTypeQuery: ObservableObject {
    @Published public var wines: [WineItemViewModel] = []

    private let wineRepository: WineRepository
    private var listener: MoWineListenerRegistration?

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    deinit {
        listener?.remove()
    }

    public func execute(userId: String, typeName: String) {
        listener?.remove()
        let userId = UserId(string: userId)
        let wineType = WineType(name: typeName)
        listener = wineRepository.getWines(userId: userId, wineType: wineType) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let wines):
                strongSelf.wines = wines.map({ .toDto($0) })
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                strongSelf.wines = []
            }
        }
    }
}
