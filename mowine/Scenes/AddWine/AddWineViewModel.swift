//
//  AddWineViewModel.swift
//  mowine
//
//  Created by Josh Freed on 2/16/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation

class AddWineViewModel: ObservableObject {
    @Published var closeModal = false
}

struct AddWine {
    struct WineType: Equatable, Identifiable {
        var id: String { name }
        let name: String
        let varieties: [WineVariety]
    }

    struct WineVariety: Equatable, Identifiable {
        var id: String { name }
        let name: String
    }
}
