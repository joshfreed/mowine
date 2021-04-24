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
    @ObservedObject var viewModel: WineCellarListViewModel
    @StateObject var searchBar = SearchBar()

    var body: some View {
        WineListView(viewModel: viewModel.makeWineListViewModel(), searchText: $searchBar.text)
            .navigationBarTitle(viewModel.navigationBarTitle)
            .add(self.searchBar)
            .onAppear(perform: {
                SwiftyBeaver.info("onAppear \(viewModel.navigationBarTitle)")
                viewModel.loadWines()
            })
    }
}

fileprivate func makeViewModel() -> WineCellarListViewModel {
    let vm = WineCellarListViewModel(
        navigationBarTitle: "Red",
        getWineByTypeQuery: GetWinesByTypeQuery(wineRepository: MemoryWineRepository(), session: FakeSession()),
        wineType: WineType(name: "Red"),
        thumbnailFetcher: FakeWineThumbnailFetcher()
    )
    vm.setWines([
        GetWinesByTypeQuery.WineDto(id: "A", name: "Merlot 1", rating: 1, type: "Red"),
        GetWinesByTypeQuery.WineDto(id: "B", name: "Merlot 2", rating: 2, type: "Red"),
        GetWinesByTypeQuery.WineDto(id: "C", name: "Merlot 3", rating: 3, type: "Red"),
    ])
    return vm
}

struct WineCellarListView_Previews: PreviewProvider {
    static var previews: some View {
        WineCellarListView(viewModel: makeViewModel())
    }
}
