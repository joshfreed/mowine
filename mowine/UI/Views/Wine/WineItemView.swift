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

    init(viewModel: WineItemViewModel, onTap: (String) -> Void = { _ in }) {
        self.init(wineId: viewModel.id, name: viewModel.name, type: viewModel.type, rating: viewModel.rating)
    }
}

struct WineItemView_Previews: PreviewProvider {
    static var previews: some View {
        WineItemView(viewModel: WineItemViewModel(id: "A", name: "2019 Fancypants", rating: 3, type: "Merlot"))
            .addPreviewEnvironment()
            .previewLayout(.sizeThatFits)
    }
}
