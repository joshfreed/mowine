//
//  WineItemView.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct WineItemView: View {
    let wineId: String
    let name: String
    let type: String
    let rating: Int

    var body: some View {
        HStack(spacing: 16) {
            WineThumbnail(wineId: wineId)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 21, weight: .bold))
                    .accessibilityIdentifier("Wine Name")

                Text(type)
                    .font(.system(size: 16))
                    .foregroundColor(Color("Dark Gray"))
                    .accessibilityIdentifier("Wine Type")

                RatingLabel(rating: rating)
            }
            Spacer()
        }
        .padding([.top, .bottom], 8)
        .contentShape(Rectangle())
    }
}

extension WineItemView {
    init(wine: MyCellar.Wine) {
        self.init(wineId: wine.id, name: wine.name, type: wine.variety, rating: wine.rating)
    }

    init(wine: GetWinesByTypeResponse.Wine) {
        self.init(wineId: wine.id, name: wine.name, type: wine.type, rating: wine.rating)
    }

    init(wine: GetTopWinesQueryResponse.TopWine) {
        self.init(wineId: wine.id, name: wine.name, type: wine.type, rating: wine.rating)
    }
}

struct WineItemView_Previews: PreviewProvider {
    static var previews: some View {
        WineItemView(wineId: "A", name: "2019 Fancypants", type: "Merlot", rating: 3)
            .addPreviewEnvironment()
            .previewLayout(.sizeThatFits)
    }
}
