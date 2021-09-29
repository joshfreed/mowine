//
//  NewWineModel.swift
//  mowine
//
//  Created by Josh Freed on 2/16/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import Model

public class NewWineModel: ObservableObject {
    @Published public var wineType: WineType?
    @Published public var wineVariety: WineVariety?
    @Published public var image: WineImage?
    @Published public var name: String = ""
    @Published public var rating: Int = 0

    public var isComplete: Bool {
        wineType != nil && !name.isEmpty && rating > 0
    }

    public init() {}
}
