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

class GetUserWinesByTypeQuery: ObservableObject {
    @Published var wines: [WineItemViewModel] = []

    private let wineRepository: WineRepository
    private var listener: MoWineListenerRegistration?

    init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    deinit {
        listener?.remove()
    }

    func execute(userId: String, typeName: String) {
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
