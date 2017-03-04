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
    let priceRow = DecimalRow("price") {
        $0.title = "Price"
        $0.placeholder = "How much was this wine?"
    }
    let noteRow = TextAreaRow("notes")

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
            +++ Section("Pairs well with")
            +++ Section("Notes")
            <<< noteRow
        
        return form
    }
}
