//
//  WineListView.swift
//  mowine
//
//  Created by Josh Freed on 10/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct WineListView: View {
    @ObservedObject var viewModel: WineListViewModelSwiftUI
    @Binding var searchText: String

    var body: some View {
        List(viewModel.listWines(searchText)) { wine in
            WineItemView(viewModel: wine)
                .contentShape(Rectangle())
                .onTapGesture { viewModel.onEditWine(wine.id) }
        }
            .listStyle(PlainListStyle())
    }
}

fileprivate func makeViewModel() -> WineListViewModelSwiftUI {
    WineListViewModelSwiftUI(wines: [
        WineItemViewModel(id: "A", name: "Merlot 1", rating: 1, type: "Red", thumbnail: nil),
        WineItemViewModel(id: "B", name: "Merlot 2", rating: 2, type: "Red", thumbnail: nil),
        WineItemViewModel(id: "C", name: "Merlot 3", rating: 3, type: "Red", thumbnail: nil),
    ])
}

struct WineListView_Previews: PreviewProvider {
    struct ShimView: View {
        @State var searchText: String = ""

        var body: some View {
            WineListView(viewModel: makeViewModel(), searchText: $searchText)
        }
    }
    static var previews: some View {
        ShimView()
    }
}
