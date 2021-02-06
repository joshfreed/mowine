//
//  WineItemView.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct WineItemViewModel: Identifiable {
    var id: String
    var name: String
    var rating: Int
    var type: String
    var thumbnail: Data?
}

struct WineItemView: View {
    let viewModel: WineItemViewModel

    var body: some View {
        HStack(spacing: 16) {
            WineThumbnail(data: viewModel.thumbnail)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.system(size: 21, weight: .bold))

                Text(viewModel.type)
                    .font(.system(size: 16))
                    .foregroundColor(Color("Dark Gray"))

                RatingView(rating: .constant(viewModel.rating))
            }
            Spacer()
        }
//        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
    }
}

struct WineItemView_Previews: PreviewProvider {
    static var previews: some View {
        WineItemView(viewModel: WineItemViewModel(id: "A", name: "2019 Fancypants", rating: 3, type: "Merlot", thumbnail: nil))
    }
}
