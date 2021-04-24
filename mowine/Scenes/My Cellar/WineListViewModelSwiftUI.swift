//
//  WineListViewModelSwiftUI.swift
//  mowine
//
//  Created by Josh Freed on 10/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import Model

class WineListViewModelSwiftUI: ObservableObject {
    var onEditWine: (String) -> Void = { _ in }
    private var wines: [WineItemViewModel] = []

    private static var instanceCount = 0

    init(wines: [WineItemViewModel]) {
        WineListViewModelSwiftUI.instanceCount += 1
        SwiftyBeaver.debug("init \(WineListViewModelSwiftUI.instanceCount)")
        self.wines = wines
    }

    deinit {
        WineListViewModelSwiftUI.instanceCount -= 1
        SwiftyBeaver.debug("deinit \(WineListViewModelSwiftUI.instanceCount)")
    }

    func listWines(_ searchText: String) -> [WineItemViewModel] {
        if searchText.isEmpty {
            return wines
        }

        let searchWords = searchText.lowercased().words

        var matchedWines = wines

        for word in searchWords {
            matchedWines = matchedWines.filter {
                $0.name.lowercased().words.contains { $0.lowercased().starts(with: word) }
            }
        }

        return matchedWines
    }
}
