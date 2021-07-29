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
import Model

class MyCellarViewModel: ObservableObject {
    @Published var isEditingWine: Bool = false
    @Published var selectedWineId: String?

    private let searchMyCellarQuery: SearchMyCellarQuery

    init(
        wineTypeRepository: WineTypeRepository,
        thumbnailFetcher: WineListThumbnailFetcher,
        searchMyCellarQuery: SearchMyCellarQuery,
        getWinesByTypeQuery: GetWinesByTypeQuery
    ) {
        SwiftyBeaver.debug("init")
        self.searchMyCellarQuery = searchMyCellarQuery
    }

    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func onEditWine(_ wineId: String) {
        selectedWineId = wineId
        isEditingWine = true
    }
}
