//
//  TopWinesViewModel.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import Model

class TopWinesViewModel: ObservableObject {
    @Published var topWines: [WineItemViewModel] = []
    @Published var errorLoadingWines = false

    private let userId: String
    private let getTopWines: GetTopWinesQuery
    
    init(userId: String, getTopWines: GetTopWinesQuery) {
        self.userId = userId
        self.getTopWines = getTopWines

        getTopWines.result
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.errorLoadingWines = false
            })
            .map { $0.topWines.map { .fromTopWine($0) } }
            .catch { [weak self] error -> Empty<[WineItemViewModel], Never> in
                SwiftyBeaver.error("\(error)")
                self?.errorLoadingWines = true
                return Empty<[WineItemViewModel], Never>()
            }
            .assign(to: &$topWines)
    }

    func loadTopWines() {
        getTopWines.execute(userId: userId)
    }
}

extension WineItemViewModel {
    static func fromTopWine(_ topWine: GetTopWinesQuery.TopWine) -> WineItemViewModel {
        WineItemViewModel(
            id: topWine.id,
            name: topWine.name,
            rating: topWine.rating,
            type: topWine.type,
            userId: topWine.userId
        )
    }
}
