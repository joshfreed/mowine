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
import Model

struct MyCellarSearchView: View {
    @EnvironmentObject var myWines: MyWinesService
    @ObservedObject private(set) var searchBar: SearchBar
    let onEditWine: (String) -> Void

    var body: some View {
        Group {
            if searchBar.text.isEmpty {
                Text("Search for your favorite wines!")
            } else if myWines.searchResults.isEmpty {
                Text("No wines match your search terms.")
            } else {
                WineListView(wines: myWines.searchResults, onTapWine: onEditWine)
            }
        }
        .onReceive(searchBar.$text) { searchBarText in
            myWines.filter(by: searchBarText)
        }
    }
}

struct MyCellarSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarSearchView(searchBar: SearchBar(), onEditWine: { _ in })
            .addPreviewEnvironment()
    }
}
