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
import MoWine_Application

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
    
    var type: EditWine.WineType? {
        types.first { $0.id == selectedTypeId }
    }
    
    var variety: EditWine.WineVariety? {
        type?.varieties.first { $0.id == selectedVarietyId }
    }
    
    private(set) var types: [EditWine.WineType] = []
    
    var varieties: [EditWine.WineVariety] {
        type?.varieties ?? []
    }
    
    func setTypes(_ types: [EditWine.WineType]) {
        self.types = types
    }
    
    func setWine(_ wine: EditWine.Wine) {
        name = wine.name
        rating = wine.rating
        selectedTypeId = types.first(where: { $0.id == wine.typeId })?.id ?? -1
        selectedVarietyId = type?.varieties.first(where: { $0.id == wine.varietyId })?.id ?? -1
        location = wine.location
        price = wine.price
        notes = wine.notes
        pairings = wine.pairings
    }
}
