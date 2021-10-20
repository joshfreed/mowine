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
    let viewModel: WineItemViewModel
    var onTap: (String) -> Void = { _ in }

    var body: some View {
        HStack(spacing: 16) {
            WineThumbnail(wineId: viewModel.id)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.system(size: 21, weight: .bold))
                    .accessibilityIdentifier("Wine Name")

                Text(viewModel.type)
                    .font(.system(size: 16))
                    .foregroundColor(Color("Dark Gray"))
                    .accessibilityIdentifier("Wine Type")

                RatingLabel(rating: viewModel.rating)
            }
            Spacer()
        }
        .padding([.top, .bottom], 8)
        .contentShape(Rectangle())
        .onTapGesture { onTap(viewModel.id) }
    }
}

struct WineItemView_Previews: PreviewProvider {
    static var previews: some View {
        WineItemView(viewModel: WineItemViewModel(id: "A", name: "2019 Fancypants", rating: 3, type: "Merlot", thumbnail: nil))
            .addPreviewEnvironment()
    }
}
