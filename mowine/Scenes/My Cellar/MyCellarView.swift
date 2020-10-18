//
//  MyCellarView.swift
//  mowine
//
//  Created by Josh Freed on 10/4/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarView: View {
    @ObservedObject private(set) var viewModel: MyCellarViewModel

    init(viewModel: MyCellarViewModel) {
        self.viewModel = viewModel
        let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
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
                .navigationBarTitle("My Cellar")
        }
        .accentColor(.mwSecondary)
        .onAppear {
            self.viewModel.loadWineTypes()
        }
    }

    private func makeView(title: String, wineType: WineType) -> WineCellarListView {
        let vm = WineCellarListViewModel(
            navigationBarTitle: title,
            wineRepository: JFContainer.shared.wineRepository,
            session: JFContainer.shared.session,
            wineType: wineType,
            thumbnailFetcher: try! JFContainer.shared.container.resolve()
        )
        return WineCellarListView(viewModel: vm)
    }
}

struct WineTypeMenuButton: View {
    let name: String
    let icon: String

    var body: some View {
        VStack {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color(UIColor.mwSecondary))
                .frame(width: 60, height: 90)

            Text(name)
                .font(.system(size: 37))
                .foregroundColor(Color(UIColor.mwSecondary))
        }
    }
}

struct MyCellarView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarView(viewModel: MyCellarViewModel(wineTypeRepository: MemoryWineTypeRepository()))
    }
}
