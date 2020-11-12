//
//  MyCellarContentView.swift
//  mowine
//
//  Created by Josh Freed on 10/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarContentView: View {
    @ObservedObject private(set) var viewModel: MyCellarViewModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: makeView(title: "Red Wines", wineType: viewModel.red)) {
                    WineTypeMenuButton(name: "Red", icon: "Red Wine Button")
                }

                Spacer()
                NavigationLink(destination: makeView(title: "White Wines", wineType: viewModel.white)) {
                    WineTypeMenuButton(name: "White", icon: "White Wine Button")
                }
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: makeView(title: "Rose", wineType: viewModel.rose)) {
                    WineTypeMenuButton(name: "Rose", icon: "Rose Button")
                }
                Spacer()
                NavigationLink(destination: makeView(title: "Bubbly", wineType: viewModel.bubbly)) {
                    WineTypeMenuButton(name: "Bubbly", icon: "Bubbly Button")
                }
                Spacer()
            }
            Spacer()
            NavigationLink(destination: makeView(title: "Other Wines", wineType: viewModel.other)) {
                Text("Other")
                    .font(.system(size: 37))
                    .foregroundColor(Color(UIColor.mwSecondary))
                    .padding(.bottom, 32)
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
