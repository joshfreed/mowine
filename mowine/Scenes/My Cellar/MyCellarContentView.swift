//
//  MyCellarContentView.swift
//  mowine
//
//  Created by Josh Freed on 10/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct MyCellarContentView: View {
    @EnvironmentObject var wineTypes: WineTypeService
    let onEditWine: (String) -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                NavigationLink(destination: makeView(title: "Red Wines", wineType: wineTypes.red)) {
                    WineTypeMenuButton(name: "Reds", icon: "Red Wine Button")
                }
                .accessibility(identifier: "Show My Red Wines")
                
                Spacer()
                
                NavigationLink(destination: makeView(title: "White Wines", wineType: wineTypes.white)) {
                    WineTypeMenuButton(name: "Whites", icon: "White Wine Button")
                }
                .accessibility(identifier: "Show My White Wines")
                
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                
                NavigationLink(destination: makeView(title: "Rose", wineType: wineTypes.rose)) {
                    WineTypeMenuButton(name: "Rosè", icon: "Rose Button")
                }
                .accessibility(identifier: "Show My Rosès")
                
                Spacer()
                
                NavigationLink(destination: makeView(title: "Bubbly", wineType: wineTypes.bubbly)) {
                    WineTypeMenuButton(name: "Bubbly", icon: "Bubbly Button")
                }
                .accessibility(identifier: "Show My Bubblies")
                
                Spacer()
            }
            Spacer()
            NavigationLink(destination: makeView(title: "Other Wines", wineType: wineTypes.other)) {
                Text("Others")
                    .font(.system(size: 37))
                    .foregroundColor(Color(UIColor.mwSecondary))
                    .padding(.bottom, 32)
                    .accessibility(identifier: "Show My Other Wines")
            }
        }
    }

    private func makeView(title: String, wineType: WineType) -> WineCellarListView {
        WineCellarListView(wineTypeId: wineType.id, navigationBarTitle: title, onEditWine: onEditWine)
    }
}

struct MyCellarContentView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarContentView(onEditWine: { _ in }).addPreviewEnvironment()
    }
}
