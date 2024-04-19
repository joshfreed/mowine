//
//  MyCellarView.swift
//  mowine
//
//  Created by Josh Freed on 10/4/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarView: View {
    @EnvironmentObject var myCellar: MyCellar

    @State private var searchText: String = ""
    @State private var searchResults: [MyCellar.Wine] = []
    
    var body: some View {
        NavigationView {
            InnerCellarView(hasSearched: !searchText.isEmpty, searchResults: searchResults)
                .navigationBarTitle("My Cellar")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.mwSecondary)
        .searchable(text: $searchText)
        .onChange(of: searchText) {
            searchResults = myCellar.search(searchText: searchText)
        }
        .analyticsScreen(name: "My Cellar", class: "MyCellarView")
    }
}

struct InnerCellarView: View {
    @Environment(\.isSearching) var isSearching

    let hasSearched: Bool
    let searchResults: [MyCellar.Wine]

    var body: some View {
        if isSearching {
            MyCellarSearchView(hasSearched: hasSearched, searchResults: searchResults)
        } else {
            MyCellarTypesView()
                .padding(20)
        }
    }
}

struct MyCellarView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarView()
            .addPreviewEnvironment()
    }
}
