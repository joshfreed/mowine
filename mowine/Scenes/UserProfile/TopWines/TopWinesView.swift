//
//  TopWinesView.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct TopWinesView: View {
    let userId: String
    @StateObject var vm = TopWinesViewModel()
    @State private var showWineDetails = false
    @State private var selectedWineId: String = ""

    var body: some View {
        List(vm.topWines) { wine in
            WineItemView(viewModel: wine)
                .onTapGesture {
                    showWineDetails = true
                    selectedWineId = wine.id
                }
        }
        .listStyle(.plain)
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
