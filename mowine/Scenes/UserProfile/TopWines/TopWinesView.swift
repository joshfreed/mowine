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
    let userId: String
    @StateObject var vm = TopWinesViewModel()
    @State private var showWineDetails = false
    @State private var selectedWineId: String = ""

    var body: some View {
        WineListView(wines: vm.topWines) { wineId in
            showWineDetails = true
            selectedWineId = wineId
        }
        .task {
            await vm.loadTopWines(userId: userId)
        }

        NavigationLink(destination: WineDetailsView(wineId: selectedWineId), isActive: $showWineDetails) {
            EmptyView()
        }
    }
}

struct TopWinesView_Previews: PreviewProvider {
    static var previews: some View {
        TopWinesView(userId: "U1")
            .addPreviewEnvironment()
            .addPreviewData()
    }
}
