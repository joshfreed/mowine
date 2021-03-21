//
//  SharedWineListView.swift
//  mowine
//
//  Created by Josh Freed on 3/7/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct SharedWineListView: View {
    let wines: [WineItemViewModel]
    var onTapWine: (String) -> Void = { _ in }

    var body: some View {
        List(wines) { wine in
            WineItemView(viewModel: wine)
                .contentShape(Rectangle())
                .onTapGesture { onTapWine(wine.id) }
        }
    }
}

struct SharedWineListView_Previews: PreviewProvider {
    static var previews: some View {
        SharedWineListView(wines: [
            .init(id: "A", name: "Merlot 1", rating: 1, type: "Red", thumbnail: nil),
            .init(id: "B", name: "Merlot 2", rating: 2, type: "Red", thumbnail: nil),
            .init(id: "C", name: "Merlot 3", rating: 3, type: "Red", thumbnail: nil),
        ])
    }
}
