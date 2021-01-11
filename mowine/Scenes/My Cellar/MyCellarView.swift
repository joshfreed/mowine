//
//  MyCellarView.swift
//  mowine
//
//  Created by Josh Freed on 10/4/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver

struct MyCellarView: View {
    @EnvironmentObject var viewModel: MyCellarViewModel
    @StateObject var searchBar = SearchBar()

    init() {
        let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            Group {
                if searchBar.isActive {
                    MyCellarSearchView(viewModel: viewModel.makeMyCellarSearchViewModel(), searchBar: searchBar)
                } else {
                    MyCellarContentView(viewModel: viewModel)
                }
            }
                .navigationBarTitle("My Cellar")
                .add(searchBar)
                .onReceive(searchBar.$text) { output in
                    viewModel.searchCellar(searchText: output)
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.mwSecondary)
        .onAppear {
            self.viewModel.loadWineTypes()
        }
        .sheet(isPresented: $viewModel.isEditingWine) {
            viewModel.selectedWineId.map {
                EditWineUIKitView(wineId: $0)
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
            .environmentObject(makeViewModel())
    }
}
