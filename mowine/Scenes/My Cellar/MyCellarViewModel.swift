//
//  MyCellarViewModel.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import Combine

class MyCellarViewModel: ObservableObject {
    var onEditWine: (String) -> Void = { _ in }

    var red: WineType { wineTypes.first { $0.name == "Red" }! }
    var white: WineType { wineTypes.first { $0.name == "White" }! }
    var rose: WineType { wineTypes.first { $0.name == "Rosé" }! }
    var bubbly: WineType { wineTypes.first { $0.name == "Bubbly" }! }
    var other: WineType { wineTypes.first { $0.name == "Other" }! }

    private let wineTypeRepository: WineTypeRepository
    private let thumbnailFetcher: WineListThumbnailFetcher
    private let searchMyCellarQuery: SearchMyCellarQuery
    private let getWinesByTypeQuery: GetWinesByTypeQuery
    private var wineTypes: [WineType] = []

    init(
        wineTypeRepository: WineTypeRepository,
        thumbnailFetcher: WineListThumbnailFetcher,
        searchMyCellarQuery: SearchMyCellarQuery,
        getWinesByTypeQuery: GetWinesByTypeQuery
    ) {
        SwiftyBeaver.debug("init")
        self.wineTypeRepository = wineTypeRepository
        self.thumbnailFetcher = thumbnailFetcher
        self.searchMyCellarQuery = searchMyCellarQuery
        self.getWinesByTypeQuery = getWinesByTypeQuery

        loadWineTypes()
    }

    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func loadWineTypes() {
        wineTypeRepository.getAll { result in
            switch result {
            case .success(let types): self.wineTypes = types
            case .failure(let error): break
            }
        }
    }

    func searchCellar(searchText: String) {
        searchMyCellarQuery.searchMyCellar(searchText: searchText)
    }

    func makeWineCellarListViewModel(title: String, wineType: WineType) -> WineCellarListViewModel {
        let vm = WineCellarListViewModel(
            navigationBarTitle: title,
            getWineByTypeQuery: getWinesByTypeQuery,
            wineType: wineType,
            thumbnailFetcher: thumbnailFetcher
        )
        vm.onEditWine = onEditWine
        return vm
    }

    func makeMyCellarSearchViewModel() -> MyCellarSearchViewModel {
        let vm = MyCellarSearchViewModel(searchMyCellarQuery: searchMyCellarQuery, thumbnailFetcher: thumbnailFetcher)
        vm.onEditWine = onEditWine
        return vm
    }
}
