//
//  TopWinesView.swift
//  mowine
//
//  Created by Josh Freed on 3/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct TopWinesView: View {
    @StateObject var vm: TopWinesViewModel
    
    var body: some View {
        SharedWineListView(wines: vm.topWines)
            .onAppear {
                vm.loadTopWines()
            }
    }
}

struct TopWinesView_Previews: PreviewProvider {
    static var previews: some View {
        TopWinesView(vm: .init(userId: "1", getTopWines: .make()))
    }
}
