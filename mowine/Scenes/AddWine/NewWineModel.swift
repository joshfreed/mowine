//
//  NewWineModel.swift
//  mowine
//
//  Created by Josh Freed on 2/16/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import UIKit
import Combine

class NewWineModel: ObservableObject {
    @Published var wineType: AddWine.WineType?
    @Published var wineVariety: AddWine.WineVariety?
    @Published var image: UIImage?
    @Published var name: String = ""
    @Published var rating: Int = 0

    var isComplete: Bool {
        wineType != nil && !name.isEmpty && rating > 0
    }
}
