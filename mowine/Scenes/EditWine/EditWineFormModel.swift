//
//  EditWineFormModel.swift
//  mowine
//
//  Created by Josh Freed on 1/31/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import UIKit.UIImage
import Model
import MoWine_Domain

class EditWineFormModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var name: String = ""
    @Published var rating: Int = 0
    @Published var selectedTypeId: Int = -1
    @Published var selectedVarietyId: Int = -1
    @Published var location: String = ""
    @Published var price: String = ""
    @Published var notes: String = ""
    @Published var pairings: [String] = []    
    
    var type: WineType? {
        types.first { $0.id == selectedTypeId }
    }
    
    var variety: WineVariety? {
        type?.varieties.first { $0.id == selectedVarietyId }
    }
    
    private(set) var types: [WineType] = []
    
    var varieties: [WineVariety] {
        type?.varieties ?? []
    }
    
    func setTypes(_ types: [WineType]) {
        self.types = types
    }
    
    func setWine(_ wine: Wine) {
        name = wine.name
        rating = Int(wine.rating)
        selectedTypeId = types.first(where: { $0.id == wine.type.id })?.id ?? -1
        selectedVarietyId = type?.varieties.first(where: { $0.id == wine.variety?.id })?.id ?? -1
        location = wine.location ?? ""
        price = wine.price ?? ""
        notes = wine.notes ?? ""
        pairings = wine.pairings
    }
}
