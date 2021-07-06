//
//  WineCellarListView.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import Model

struct WineCellarListView: View {
    @EnvironmentObject var myWines: MyWinesService
    let wineTypeId: Int
    let navigationBarTitle: String
    let onEditWine: (String) -> Void

    @State private var searchText: String = ""

    private let wineFilteringService = WineFilteringService()

    private var allWines: [WineItemViewModel] {
        myWines.wines[wineTypeId, default: []]
    }

    private var searchResults: [WineItemViewModel] {
        if searchText.isEmpty {
            return allWines
        } else {
            return wineFilteringService.filter(wines: allWines, by: searchText)
        }
    }

    var body: some View {
        WineListView(wines: searchResults, onTapWine: onEditWine)
            .navigationBarTitle(navigationBarTitle)
            .searchable(text: $searchText)
    }
}

struct WineCellarListView_Previews: PreviewProvider {
    static var previews: some View {
        WineCellarListView(wineTypeId: 1, navigationBarTitle: "Red", onEditWine: { _ in })
            .addPreviewEnvironment()
    }
}
