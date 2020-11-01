//
//  MyCellarSearchViewModel.swift
//  mowine
//
//  Created by Josh Freed on 10/31/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import Combine
import SwiftyBeaver

class MyCellarSearchViewModel: ObservableObject {
    let searchMyCellarQuery: SearchMyCellarQuery
    @Published var results: [WineItemViewModel] = []
    var onEditWine: (String) -> Void = { _ in }

    private var cancellable: AnyCancellable?

    init(searchMyCellarQuery: SearchMyCellarQuery) {
        SwiftyBeaver.debug("init")
        self.searchMyCellarQuery = searchMyCellarQuery

        cancellable = searchMyCellarQuery.results
            .map { $0.map { self.toViewModel(wine: $0) } }
            .sink(receiveCompletion: { completion in

            }, receiveValue: { [weak self] models in
                self?.results = models
            })
    }

    deinit {
        SwiftyBeaver.debug("deinit")
    }

    private func toViewModel(wine: SearchMyCellarQuery.WineDto) -> WineItemViewModel {
        WineItemViewModel(
            id: wine.id,
            name: wine.name,
            rating: wine.rating,
            type: wine.type,
            thumbnail: nil
        )
    }
}
