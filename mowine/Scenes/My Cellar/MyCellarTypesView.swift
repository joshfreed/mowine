//
//  MyCellarContentView.swift
//  mowine
//
//  Created by Josh Freed on 10/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarTypesView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 64) {
            LazyVGrid(columns: columns, spacing: 80) {
                NavigationLink(destination: MyCellarWineListView(wineTypeId: "Red", title: "Red Wines")) {
                    WineTypeMenuButton(name: "Reds", icon: "Red Wine Button")
                }
                .accessibilityIdentifier("Show My Red Wines")

                NavigationLink(destination: MyCellarWineListView(wineTypeId: "White", title: "White Wines")) {
                    WineTypeMenuButton(name: "Whites", icon: "White Wine Button")
                }
                .accessibilityIdentifier("Show My White Wines")

                NavigationLink(destination: MyCellarWineListView(wineTypeId: "Rosé", title: "Rosé Wines")) {
                    WineTypeMenuButton(name: "Rosé", icon: "Rose Button")
                }
                .accessibilityIdentifier("Show My Rosés")

                NavigationLink(destination: MyCellarWineListView(wineTypeId: "Bubbly", title: "Bubblies")) {
                    WineTypeMenuButton(name: "Bubbly", icon: "Bubbly Button")
                }
                .accessibilityIdentifier("Show My Bubblies")
            }

            NavigationLink(destination: MyCellarWineListView(wineTypeId: "Other", title: "Other Wines")) {
                WineTypeMenuButton(name: "Others", icon: "")
            }
            .accessibilityIdentifier("Show My Other Wines")
        }
    }
}

struct MyCellarContentView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarTypesView()
    }
}
