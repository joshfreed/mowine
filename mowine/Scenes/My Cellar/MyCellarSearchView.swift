//
//  MyCellarSearchView.swift
//  mowine
//
//  Created by Josh Freed on 10/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarSearchView: View {
    let hasSearched: Bool
    let searchResults: [MyCellar.Wine]

    var body: some View {
        if hasSearched {
            MyCellarSearchResults(searchResults: searchResults)
        } else {
            MyCellarSearchPlaceholder()
        }
    }
}

struct MyCellarSearchPlaceholder: View {
    var body: some View {
        Text("Search for your favorite wines!")
    }
}

struct MyCellarSearchResults: View {
    let searchResults: [MyCellar.Wine]

    @State private var selectedWine: MyCellar.Wine? = nil

    var body: some View {
        if searchResults.isEmpty {
            Text("No wines match your search terms.")
        } else {
            List(searchResults) { wine in
                WineItemView(wine: wine)
                    .onTapGesture { selectedWine = wine }
            }
            .listStyle(.plain)
            .sheet(item: $selectedWine) { wine in
                EditWineView(wineId: wine.id)
            }
        }
    }
}

struct MyCellarSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarSearchView(hasSearched: false, searchResults: [])
            .addPreviewEnvironment()
    }
}
