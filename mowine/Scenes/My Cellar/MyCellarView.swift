//
//  MyCellarView.swift
//  mowine
//
//  Created by Josh Freed on 10/4/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import Model

struct MyCellarView: View {
    @StateObject var viewModel: MyCellarViewModel = MyCellarViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            InnerCellarView(searchText: $searchText)
                .navigationBarTitle("My Cellar")
                .environmentObject(viewModel)
        }
        .searchable(text: $searchText)
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.mwSecondary)
        .sheet(isPresented: $viewModel.isEditingWine) {
            viewModel.selectedWineId.map {
                EditWineView(vm: .init(wineId: $0))
            }
        }
        .analyticsScreen(name: "My Cellar", class: "MyCellarView")
    }
}

struct InnerCellarView: View {
    @EnvironmentObject var viewModel: MyCellarViewModel
    @Environment(\.isSearching) var isSearching
    @Binding var searchText: String

    var body: some View {
        if isSearching {
            MyCellarSearchView(searchText: $searchText, onEditWine: { viewModel.onEditWine($0) })
        } else {
            MyCellarContentView(onEditWine: { viewModel.onEditWine($0) })
        }
    }
}

struct MyCellarView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarView()
            .addPreviewEnvironment()
    }
}
