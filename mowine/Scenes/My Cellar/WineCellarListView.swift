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
        }
            .listStyle(PlainListStyle())
            .navigationBarTitle(viewModel.navigationBarTitle)
            .onAppear(perform: {
                SwiftyBeaver.info("onAppear \(viewModel.navigationBarTitle)")
                viewModel.loadWines()
            })
    }
}

struct WineCellarListView_Previews: PreviewProvider {
    static var previews: some View {
        WineCellarListView(viewModel: WineCellarListViewModel(
                            navigationBarTitle: "Red",
                            wineRepository: MemoryWineRepository(),
                            session: FakeSession(),
                            wineType: WineType(name: "Red"),
                            thumbnailFetcher: FakeWineThumbnailFetcher()
        ))
    }
}
