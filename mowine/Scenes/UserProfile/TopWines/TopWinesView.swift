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
    @ObservedObject var vm: TopWinesViewModel

    var body: some View {
        if vm.errorLoadingWines {
            Text("There was an error loading these wines :(")
        } else if vm.topWines.count == 0 {
            Text("This user has not rated any wines yet")
        } else {
            TopWinesList(topWines: vm.topWines)
        }
    }
}

struct TopWinesList: View {
    let topWines: [GetTopWinesResponse.TopWine]

    var body: some View {
        List(topWines) { wine in
            WineDetailsNavigationLink(wine: wine)
        }
        .listStyle(.plain)
    }
}

struct TopWinesView_Previews: PreviewProvider {
    static var vm: TopWinesViewModel = {
        let vm = TopWinesViewModel()
        vm.topWines = [
            .init(id: "1", name: "First Wine", rating: 5, type: "Red")
        ]
        return vm
    }()

    static var errorVm: TopWinesViewModel = {
        let vm = TopWinesViewModel()
        vm.errorLoadingWines = true
        return vm
    }()

    static var previews: some View {
        TopWinesView(vm: vm)
            .addPreviewEnvironment()
            .addPreviewData()
    }
}
