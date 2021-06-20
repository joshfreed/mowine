//
//  WineListView.swift
//  mowine
//
//  Created by Josh Freed on 10/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct WineListView: View {
    let wines: [WineItemViewModel]
    var onTapWine: (String) -> Void = { _ in }

    var body: some View {
        List(wines) { wine in
            WineItemView(viewModel: wine, onTap: onTapWine)
        }
    }
}

struct WineListView_Previews: PreviewProvider {
    static var previews: some View {
        WineListView(wines: [
            .init(id: "A", name: "Merlot 1", rating: 1, type: "Red", thumbnail: nil),
            .init(id: "B", name: "Merlot 2", rating: 2, type: "Red", thumbnail: nil),
            .init(id: "C", name: "Merlot 3", rating: 3, type: "Red", thumbnail: nil),
        ])
            .addPreviewEnvironment()
    }
}
