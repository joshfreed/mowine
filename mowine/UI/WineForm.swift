//
//  WineForm.swift
//  mowine
//
//  Created by Josh Freed on 2/18/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import Eureka

class WineForm: NSObject {
    let nameRow = TextRow("name") {
        $0.title = "Name"
        $0.placeholder = "Fancy Wine Name"
    }
    let ratingRow = RatingRow("rating") {
        $0.title = "Rating"
        $0.cell.selectionStyle = .none
    }
    let photoRow = PhotoRow("photo") {
        $0.title = nil
    }
    let varietyRow = PushRow<String>("variety") {
        $0.title = "Variety"
        $0.options = []
    }
    let typeRow = PushRow<WineTypeViewModel>("type") {
        $0.title = "Type"
        $0.options = []
    }
    let locationRow = TextRow("location") {
        $0.title = "Location"
        $0.placeholder = "Where did I find this wine?"
    }
    let priceRow = TextRow("price") {
        $0.title = "Price"
        $0.placeholder = "How much was this wine?"
    }
    let noteRow = TextAreaRow("notes")
    
    var pairingsSection: MultivaluedSection!

    func makeWineForm() -> Form {
        typeRow.onChange { row in
            if let value = row.value {
                self.varietyRow.options = value.varieties
            } else {
                self.varietyRow.options = []
            }
            
            self.varietyRow.value = nil
            self.varietyRow.updateCell()
        }
        
        pairingsSection = MultivaluedSection(multivaluedOptions: [.Insert, .Delete], header: "Pairs well with", footer: "List some foods that this wine pairs well with.") {
            $0.tag = "pairings"
            $0.multivaluedRowToInsertAt = { index in
                return NameRow("pairing_\(index + 1)") {
                    $0.placeholder = "e.g. Sushi, Cheese, etc"
                }
            }
        }
        
        let form = Section()
            <<< nameRow
            <<< ratingRow
            +++ Section(header: "Photo", footer: "Take or select a photo of this wine.")
            <<< photoRow
            +++ Section()
            <<< typeRow
            <<< varietyRow
            <<< locationRow
            <<< priceRow
            +++ pairingsSection
            +++ Section("Notes")
            <<< noteRow
        
        return form
    }
}
