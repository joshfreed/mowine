//
//  WineDetailsNavigationView.swift
//  mowine
//
//  Created by Josh Freed on 11/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct WineDetailsNavigationLink: View {
    let wineId: String
    let name: String
    let type: String
    let rating: Int

    var body: some View {
        ZStack {
            WineItemView(wineId: wineId, name: name, type: type, rating: rating)
            NavigationLink(destination: WineDetailsView(wineId: wineId)) {
                EmptyView()
            }.hidden()
        }
    }
}

extension WineDetailsNavigationLink {
    init(wine: GetWinesByTypeResponse.Wine) {
        self.init(wineId: wine.id, name: wine.name, type: wine.type, rating: wine.rating)
    }

    init(wine: GetTopWinesQueryResponse.TopWine) {
        self.init(wineId: wine.id, name: wine.name, type: wine.type, rating: wine.rating)
    }
}

struct WineDetailsNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        WineDetailsNavigationLink(wineId: "W1", name: "This Cool Wine", type: "Merlot", rating: 3)
            .previewLayout(.sizeThatFits)
    }
}
