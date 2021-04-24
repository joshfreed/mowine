//
//  TopWinesView.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct TopWinesView: View {
    @StateObject var vm: TopWinesViewModel
    @State private var showWineDetails = false
    @State private var selectedWineId: String = ""

    var body: some View {
        SharedWineListView(wines: vm.topWines) { wineId in
            showWineDetails = true
            selectedWineId = wineId
        }
        .onAppear {
            vm.loadTopWines()
        }

        NavigationLink(destination: WineDetailsView(wineId: selectedWineId), isActive: $showWineDetails) {
            EmptyView()
        }
    }
}

struct TopWinesView_Previews: PreviewProvider {
    static var previews: some View {
        TopWinesView(vm: .init(userId: "1", getTopWines: .make()))
    }
}
