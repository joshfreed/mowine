//
//  MyCellarContentView.swift
//  mowine
//
//  Created by Josh Freed on 10/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarContentView: View {
    private(set) var viewModel: MyCellarViewModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                NavigationLink(destination: makeView(title: "Red Wines", wineType: viewModel.red)) {
                    WineTypeMenuButton(name: "Reds", icon: "Red Wine Button")
                }
                .accessibility(identifier: "Show My Red Wines")
                
                Spacer()
                
                NavigationLink(destination: makeView(title: "White Wines", wineType: viewModel.white)) {
                    WineTypeMenuButton(name: "Whites", icon: "White Wine Button")
                }
                .accessibility(identifier: "Show My White Wines")
                
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                
                NavigationLink(destination: makeView(title: "Rose", wineType: viewModel.rose)) {
                    WineTypeMenuButton(name: "Rosè", icon: "Rose Button")
                }
                .accessibility(identifier: "Show My Rosès")
                
                Spacer()
                
                NavigationLink(destination: makeView(title: "Bubbly", wineType: viewModel.bubbly)) {
                    WineTypeMenuButton(name: "Bubbly", icon: "Bubbly Button")
                }
                .accessibility(identifier: "Show My Bubblies")
                
                Spacer()
            }
            Spacer()
            NavigationLink(destination: makeView(title: "Other Wines", wineType: viewModel.other)) {
                Text("Others")
                    .font(.system(size: 37))
                    .foregroundColor(Color(UIColor.mwSecondary))
                    .padding(.bottom, 32)
                    .accessibility(identifier: "Show My Other Wines")
            }

        }
    }

    private func makeView(title: String, wineType: WineType) -> WineCellarListView {
        let vm = viewModel.makeWineCellarListViewModel(title: title, wineType: wineType)
        return WineCellarListView(viewModel: vm)
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

struct MyCellarContentView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarContentView(viewModel: makeViewModel())
    }
}
