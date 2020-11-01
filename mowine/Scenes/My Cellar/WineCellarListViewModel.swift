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
    let getWineByTypeQuery: GetWinesByTypeQuery
    let wineType: WineType
    let thumbnailFetcher: WineListThumbnailFetcher
    var onEditWine: (String) -> Void = { _ in }

    @Published var wines: [WineItemViewModel] = []

    private var isSubscribed = false
    private var wineUpdatedSubscription: AnyCancellable?
    private var getWinesSubscription: AnyCancellable?

    init(
        navigationBarTitle: String,
        getWineByTypeQuery: GetWinesByTypeQuery,
        wineType: WineType,
        thumbnailFetcher: WineListThumbnailFetcher
    ) {
        SwiftyBeaver.debug("init")
        self.navigationBarTitle = navigationBarTitle
        self.getWineByTypeQuery = getWineByTypeQuery
        self.wineType = wineType
        self.thumbnailFetcher = thumbnailFetcher
    }

    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func loadWines() {
        guard !isSubscribed else {
            SwiftyBeaver.debug("Already subscribed; not subscribing again")
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

        getWinesSubscription = AnyCancellable(
            getWineByTypeQuery
                .getWinesByType(wineType)
                .sink(receiveCompletion: { [weak self] error in
                    SwiftyBeaver.error("\(error)")
                    self?.isSubscribed = false
                }, receiveValue: { [weak self] wines in
                    SwiftyBeaver.debug("Received wines: \(wines)")
                    self?.isSubscribed = true
                    self?.setWines(wines)
                })
        )
    }

    func setWineViewModels(_ wines: [WineItemViewModel]) {
        self.wines = wines
    }

//    func setWines(_ wines: [Wine]) {
//        self.wines = wines
//            .sorted(by: { $0.rating > $1.rating })
//            .map { makeWineItemViewModel(wine: $0) }
//        wines.forEach { fetchThumbnail(for: $0) }
//    }
//
//    private func makeWineItemViewModel(wine: Wine) -> WineItemViewModel {
//        WineItemViewModel(
//            id: wine.id.asString,
//            name: wine.name,
//            rating: Int(wine.rating),
//            type: self.wineType.name,
//            thumbnail: nil
//        )
//    }
//
//    private func fetchThumbnail(for wine: Wine) {
//        thumbnailFetcher.fetchThumbnail(for: wine) { result in
//            switch result {
//            case .success(let data):
//                self.setThumbnail(data, for: wine.id.asString)
//            case .failure(let error):
//                SwiftyBeaver.error("\(error)")
//                Crashlytics.crashlytics().record(error: error)
//            }
//        }
//    }

    private func setThumbnail(_ data: Data?, for wineId: String) {
        guard let index = self.wines.firstIndex(where: { $0.id == wineId }) else {
            return
        }

        wines[index].thumbnail = data
    }

    func setWines(_ wines: [GetWinesByTypeQuery.WineDto]) {
        self.wines = wines
            .sorted(by: { $0.rating > $1.rating })
            .map { makeWineItemViewModel(wine: $0) }
        wines.forEach { fetchThumbnail(for: $0) }
    }

    private func makeWineItemViewModel(wine: GetWinesByTypeQuery.WineDto) -> WineItemViewModel {
        WineItemViewModel(
            id: wine.id,
            name: wine.name,
            rating: wine.rating,
            type: wine.type,
            thumbnail: nil
        )
    }

    private func fetchThumbnail(for wine: GetWinesByTypeQuery.WineDto) {
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

    func makeWineListViewModel() -> WineListViewModelSwiftUI {
        let vm = WineListViewModelSwiftUI(wines: wines)
        vm.onEditWine = onEditWine
        return vm
    }
}

