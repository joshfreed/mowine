//
//  MyCellarContentView.swift
//  mowine
//
//  Created by Josh Freed on 10/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarContentView: View {
    @EnvironmentObject var vm: MyCellarViewModel
    let onEditWine: (String) -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                NavigationLink(destination: makeView(title: "Red Wines", wineTypeId: vm.redId)) {
                    WineTypeMenuButton(name: "Reds", icon: "Red Wine Button")
                }
                .accessibilityIdentifier("Show My Red Wines")
                
                Spacer()
                
                NavigationLink(destination: makeView(title: "White Wines", wineTypeId: vm.whiteId)) {
                    WineTypeMenuButton(name: "Whites", icon: "White Wine Button")
                }
                .accessibilityIdentifier("Show My White Wines")
                
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                
                NavigationLink(destination: makeView(title: "Rose", wineTypeId: vm.roseId)) {
                    WineTypeMenuButton(name: "Rosè", icon: "Rose Button")
                }
                .accessibilityIdentifier("Show My Rosès")
                
                Spacer()
                
                NavigationLink(destination: makeView(title: "Bubbly", wineTypeId: vm.bubblyId)) {
                    WineTypeMenuButton(name: "Bubbly", icon: "Bubbly Button")
                }
                .accessibilityIdentifier("Show My Bubblies")
                
                Spacer()
            }
            Spacer()
            NavigationLink(destination: makeView(title: "Other Wines", wineTypeId: vm.otherId)) {
                Text("Others")
                    .font(.system(size: 37))
                    .foregroundColor(Color(UIColor.mwSecondary))
                    .padding(.bottom, 32)
                    .accessibilityIdentifier("Show My Other Wines")
            }
        }
    }

    private func makeView(title: String, wineTypeId: Int) -> WineCellarListView {
        WineCellarListView(wineTypeId: wineTypeId, navigationBarTitle: title, onEditWine: onEditWine)
    }
}

struct MyCellarContentView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarContentView(onEditWine: { _ in })
            .addPreviewEnvironment()
    }
}
