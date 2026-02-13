//
//  WineDetailsHeaderView.swift
//  mowine
//
//  Created by Josh Freed on 11/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct WineDetailsHeaderView: View {
    let wine: GetWineDetailsResponse

    var body: some View {
        VStack(spacing: 16) {
            WineThumbnail(wineId: wine.id, size: 172)
            Text(wine.name)
                .foregroundColor(.white)
                .fontWeight(.black)
                .font(.system(size: 28))
            RatingLabel(rating: wine.rating, starSize: 30, showEmptyStars: false)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding([.top, .bottom], 24)
        .background(Color(.mwPrimary))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let wine = GetWineDetailsResponse(
        id: "W1",
        name: "Woodbridge 2019",
        rating: 4,
        varietyName: "Merlot",
        typeName: "Red",
        price: "",
        location: ""
    )

    WineDetailsHeaderView(wine: wine)
        .addPreviewEnvironment()
        .addPreviewData()
}
