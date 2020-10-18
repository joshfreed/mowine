//
//  WineCellarListViewModel.swift
//  mowine
//
//  Created by Josh Freed on 10/17/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import SwiftyBeaver
import FirebaseCrashlytics


class WineCellarListViewModel: ObservableObject {
    let navigationBarTitle: String
    let wineRepository: WineRepository
    let session: Session
    let wineType: WineType
    let thumbnailFetcher: WineListThumbnailFetcher
    @Published private(set) var wines: [WineItemViewModel] = []

    private var isSubscribed = false

    init(
        navigationBarTitle: String,
        wineRepository: WineRepository,
        session: Session,
        wineType: WineType,
        thumbnailFetcher: WineListThumbnailFetcher
    ) {
        SwiftyBeaver.debug("init")
        self.navigationBarTitle = navigationBarTitle
        self.wineRepository = wineRepository
        self.session = session
        self.wineType = wineType
        self.thumbnailFetcher = thumbnailFetcher
    }

    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func loadWines() {
        guard !isSubscribed else { return }

        guard let userId = session.currentUserId else {
            return
        }

        wineRepository.getWines(userId: userId, wineType: wineType) { result in
            switch result {
            case .success(let wines):
                self.isSubscribed = true
                self.setWines(wines)
            case .failure(let error):
                self.isSubscribed = false
            }
        }
    }

    private func setWines(_ wines: [Wine]) {
        self.wines = wines
            .sorted(by: { $0.rating > $1.rating })
            .map { makeWineItemViewModel(wine: $0) }
        wines.forEach { fetchThumbnail(for: $0) }
    }

    private func fetchThumbnail(for wine: Wine) {
        thumbnailFetcher.fetchThumbnail(for: wine) { result in
            switch result {
            case .success(let data):
                if let index = self.wines.firstIndex(where: { $0.id == wine.id.asString }) {
                    self.wines[index].thumbnail = data
                }
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }

    private func makeWineItemViewModel(wine: Wine) -> WineItemViewModel {
        WineItemViewModel(
            id: wine.id.asString,
            name: wine.name,
            rating: Int(wine.rating),
            type: self.wineType.name,
            thumbnail: nil
        )
    }
}
