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
    @EnvironmentObject var viewModel: MyCellarViewModel
    @StateObject var searchBar = SearchBar()

    var body: some View {
        NavigationView {
            Group {
                if searchBar.isActive {
                    MyCellarSearchView(searchBar: searchBar, onEditWine: { viewModel.onEditWine($0) })
                } else {
                    MyCellarContentView(onEditWine: { viewModel.onEditWine($0) })
                }
            }
                .navigationBarTitle("My Cellar")
                .add(searchBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.mwSecondary)
        .sheet(isPresented: $viewModel.isEditingWine) {
            viewModel.selectedWineId.map {
                EditWineView(wineId: $0)
            }
        }
    }
}

fileprivate func makeViewModel() -> MyCellarViewModel {
    MyCellarViewModel(
        wineTypeRepository: MemoryWineTypeRepository(),
        thumbnailFetcher: FakeWineThumbnailFetcher(),
        searchMyCellarQuery: SearchMyCellarQuery(wineRepository: MemoryWineRepository(), session: FakeSession()),
        getWinesByTypeQuery: GetWinesByTypeQuery(wineRepository: MemoryWineRepository(), session: FakeSession())
    )
}

struct MyCellarView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarView()
            .addPreviewEnvironment()
    }
}
