//
//  MyCellarWineListView.swift
//  mowine
//
//  Created by Josh Freed on 10/26/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarWineListView: View {
    @EnvironmentObject var myCellar: MyCellar

    let wineTypeId: String
    let title: String

    @State private var selectedWine: MyCellar.Wine? = nil
    @State private var searchText: String = ""

    var wines: [MyCellar.Wine] {
        if searchText.isEmpty {
            return myCellar.getWinesByType(wineTypeId)
        } else {
            return myCellar.filterWines(by: wineTypeId, and: searchText)
        }
    }

    var body: some View {
        List(wines) { wine in
            WineItemView(wine: wine)
                .onTapGesture { selectedWine = wine }
        }
        .listStyle(.plain)
        .toolbarTitleDisplayMode(.inline)
        .navigationBarTitle(title)
        .searchable(text: $searchText)
        .accessibilityIdentifier("WineCellarListView")
        .sheet(item: $selectedWine) { wine in
            EditWineView(wineId: wine.id)
        }
    }
}

struct MyCellarWineListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyCellarWineListView(wineTypeId: "Red", title: "Red Wines")
                .environmentObject(MyCellar.fake())
        }
    }
}
