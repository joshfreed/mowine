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

    var body: some View {
        Group {
            if vm.errorLoadingWines {
                Text("There was an error loading these wines :(")
            } else if vm.topWines.count == 0 {
                Text("This user has not rated any wines yet")
            } else {
                TopWinesList(topWines: vm.topWines)
            }
        }
        .task {
            await vm.loadTopWines(userId: userId)
        }
    }
}

struct TopWinesList: View {
    let topWines: [GetTopWinesQueryResponse.TopWine]

    var body: some View {
        List(topWines) { wine in
            ZStack {
                WineItemView(wine: wine)
                NavigationLink(destination: WineDetailsView(wineId: wine.id)) {
                    EmptyView()
                }.hidden()
            }
        }
        .listStyle(.plain)
    }
}

struct TopWinesView_Previews: PreviewProvider {
    static var errorVm: TopWinesViewModel = {
        let vm = TopWinesViewModel()
        vm.errorLoadingWines = true
        return vm
    }()

    static var previews: some View {
        TopWinesView(userId: "U1")
            .addPreviewEnvironment()
            .addPreviewData()
    }
}
