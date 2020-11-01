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
import FirebaseCrashlytics

class MyCellarSearchViewModel: ObservableObject {
    let searchMyCellarQuery: SearchMyCellarQuery
    let thumbnailFetcher: WineListThumbnailFetcher

    @Published var results: [WineItemViewModel] = []

    var onEditWine: (String) -> Void = { _ in }

    private var cancellable: AnyCancellable?
    private var cancellable2: AnyCancellable?

    init(searchMyCellarQuery: SearchMyCellarQuery, thumbnailFetcher: WineListThumbnailFetcher) {
        SwiftyBeaver.debug("init")
        self.searchMyCellarQuery = searchMyCellarQuery
        self.thumbnailFetcher = thumbnailFetcher

        cancellable = searchMyCellarQuery.results
            .map { $0.map { self.toViewModel(wine: $0) } }
            .sink(receiveCompletion: { completion in
                SwiftyBeaver.error("\(completion)")
            }, receiveValue: { [weak self] models in
                self?.results = models
                self?.results.forEach { self?.fetchThumbnail(for: $0) }
            })

        cancellable2 = NotificationCenter.default.publisher(for: .wineUpdated).sink { [weak self] notification in
            guard let wineId = notification.userInfo?["wineId"] as? String else { return }
            guard let thumbnail = notification.userInfo?["thumbnail"] as? Data else { return }
            self?.setThumbnail(thumbnail, for: wineId)
        }
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

    private func fetchThumbnail(for wine: WineItemViewModel) {
        thumbnailFetcher.fetchThumbnail(for: wine.id) { result in
            switch result {
            case .success(let data):
                self.setThumbnail(data, for: wine.id)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }

    private func setThumbnail(_ data: Data?, for wineId: String) {
        guard let index = self.results.firstIndex(where: { $0.id == wineId }) else {
            return
        }

        results[index].thumbnail = data
    }
}
