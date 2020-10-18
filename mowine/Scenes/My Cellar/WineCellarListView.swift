//
//  WineCellarListView.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver

struct WineCellarListView: View {
    @ObservedObject var viewModel: WineCellarListViewModel

    var body: some View {
        List(viewModel.wines) { wine in
            WineItemView(viewModel: wine)
                .contentShape(Rectangle())
                .onTapGesture { viewModel.onEditWine(wine.id) }
        }
            .listStyle(PlainListStyle())
            .navigationBarTitle(viewModel.navigationBarTitle)
            .onAppear(perform: {
                SwiftyBeaver.info("onAppear \(viewModel.navigationBarTitle)")
                viewModel.loadWines()
            })
    }
}

fileprivate func makeViewModel() -> WineCellarListViewModel {
    let vm = WineCellarListViewModel(
        navigationBarTitle: "Red",
        wineRepository: MemoryWineRepository(),
        session: FakeSession(),
        wineType: WineType(name: "Red"),
        thumbnailFetcher: FakeWineThumbnailFetcher()
    )
    vm.wines = [
        WineItemViewModel(id: "A", name: "Merlot 1", rating: 1, type: "Red", thumbnail: nil),
        WineItemViewModel(id: "B", name: "Merlot 2", rating: 2, type: "Red", thumbnail: nil),
        WineItemViewModel(id: "C", name: "Merlot 3", rating: 3, type: "Red", thumbnail: nil),
    ]
    return vm
}

struct WineCellarListView_Previews: PreviewProvider {
    static var previews: some View {
        WineCellarListView(viewModel: makeViewModel())
    }
}
