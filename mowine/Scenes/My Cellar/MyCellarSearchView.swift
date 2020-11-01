//
//  MyCellarSearchView.swift
//  mowine
//
//  Created by Josh Freed on 10/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import Combine
import SwiftyBeaver

struct MyCellarSearchView: View {
    @ObservedObject var viewModel: MyCellarSearchViewModel
    @ObservedObject private(set) var searchBar: SearchBar

    var body: some View {
        if searchBar.text.isEmpty {
            Text("Search for your favorite wines!")
        } else if viewModel.results.isEmpty {
            Text("No wines match your search terms.")
        } else {
            List(viewModel.results) { wine in
                WineItemView(viewModel: wine)
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.onEditWine(wine.id) }
            }
                .listStyle(PlainListStyle())
        }
    }
}

struct MyCellarSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarSearchView(
            viewModel: MyCellarSearchViewModel(
                searchMyCellarQuery: SearchMyCellarQuery(wineRepository: MemoryWineRepository(), session: FakeSession())
            ),
            searchBar: SearchBar()
        )
    }
}
