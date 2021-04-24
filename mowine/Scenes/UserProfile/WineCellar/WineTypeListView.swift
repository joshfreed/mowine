//
//  WineTypeListView.swift
//  mowine
//
//  Created by Josh Freed on 3/21/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct WineTypeListView: View {
    @EnvironmentObject var query: GetUserWinesByTypeQuery
    let userId: String
    let typeName: String

    @State private var showWineDetails = false
    @State private var selectedWineId: String = ""

    var body: some View {
        SharedWineListView(wines: query.wines) { wineId in
            showWineDetails = true
            selectedWineId = wineId
        }
        .onAppear {
            query.execute(userId: userId, typeName: typeName)
        }

        NavigationLink(destination: WineDetailsView(wineId: selectedWineId), isActive: $showWineDetails) {
            EmptyView()
        }
    }
}

struct WineTypeListView_Previews: PreviewProvider {
    static var query: GetUserWinesByTypeQuery = {
        let q = GetUserWinesByTypeQuery(wineRepository: MemoryWineRepository())
        q.wines = [
            .init(id: "A", name: "My Cool Wine", rating: 4, type: "Red", thumbnail: nil)
        ]
        return q
    }()

    static var previews: some View {
        WineTypeListView(userId: "1", typeName: "Red")
            .environmentObject(query)
    }
}
