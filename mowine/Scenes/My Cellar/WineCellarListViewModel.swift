//
//  WineCellarListViewModel.swift
//  mowine
//
//  Created by Josh Freed on 10/17/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import Combine
import FirebaseCrashlytics

class WineCellarListViewModel: ObservableObject {
    let navigationBarTitle: String
    let wineRepository: WineRepository
    let session: Session
    let wineType: WineType
    let thumbnailFetcher: WineListThumbnailFetcher
    var onEditWine: (String) -> Void = { _ in }

    @Published var wines: [WineItemViewModel] = []

    private var isSubscribed = false
    private var wineUpdatedSubscription: AnyCancellable?

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

        wineUpdatedSubscription = NotificationCenter.default.publisher(for: .wineUpdated).sink { [weak self] notification in
            guard let wineId = notification.userInfo?["wineId"] as? String else {
                return
            }

            guard let thumbnail = notification.userInfo?["thumbnail"] as? Data else {
                return
            }

            self?.setThumbnail(thumbnail, for: wineId)
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

    func setWines(_ wines: [Wine]) {
        self.wines = wines
            .sorted(by: { $0.rating > $1.rating })
            .map { makeWineItemViewModel(wine: $0) }
        wines.forEach { fetchThumbnail(for: $0) }
    }

    func setWineViewModels(_ wines: [WineItemViewModel]) {
        self.wines = wines
    }

    private func fetchThumbnail(for wine: Wine) {
        thumbnailFetcher.fetchThumbnail(for: wine) { result in
            switch result {
            case .success(let data):
                self.setThumbnail(data, for: wine.id.asString)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }

    private func setThumbnail(_ data: Data?, for wineId: String) {
        guard let index = self.wines.firstIndex(where: { $0.id == wineId }) else {
            return
        }

        wines[index].thumbnail = data
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

    func makeWineListViewModel() -> WineListViewModelSwiftUI {
        let vm = WineListViewModelSwiftUI(wines: wines)
        vm.onEditWine = onEditWine
        return vm
    }
}

