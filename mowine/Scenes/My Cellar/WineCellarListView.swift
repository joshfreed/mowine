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

    private let wineFilteringService = WineFilteringService()
    private var allWines: [WineItemViewModel] {
        myWines.wines[wineTypeId, default: []]
    }

    @StateObject private var searchBar = SearchBar()
    @State private var searchResults: [WineItemViewModel] = []

    var body: some View {
        WineListView(wines: searchResults, onTapWine: onEditWine)
            .navigationBarTitle(navigationBarTitle)
            .add(searchBar)
            .onReceive(searchBar.$text) { searchBarText in
                searchResults = wineFilteringService.filter(wines: allWines, by: searchBarText)
            }
            .onAppear {
                searchResults = allWines
            }
    }
}

struct WineCellarListView_Previews: PreviewProvider {
    static var previews: some View {
        WineCellarListView(wineTypeId: 1, navigationBarTitle: "Red", onEditWine: { _ in })
            .addPreviewEnvironment()
    }
}
