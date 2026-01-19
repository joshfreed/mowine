//
//  MyCellarWineListView.swift
//  mowine
//
//  Created by Josh Freed on 10/26/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarWineListView: View {
    @Environment(MyCellar.self) var myCellar

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
        .accessibilityIdentifier("WineCellarListView")
        .navigationBarTitle(title)
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                AddNewWineButton()
            }
        }
        .sheet(item: $selectedWine) { wine in
            EditWineView(wineId: wine.id)
        }
    }
}

struct MyCellarWineListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyCellarWineListView(wineTypeId: "Red", title: "Red Wines")
                .environment(MyCellar.fake())
        }
    }
}
