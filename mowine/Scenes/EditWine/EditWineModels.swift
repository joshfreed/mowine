//
//  EditWineModels.swift
//  mowine
//
//  Created by Josh Freed on 2/18/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

struct EditWine {

    struct FetchWine {

        struct Request {
        }

        struct Response {
            let wine: Wine
            let wineTypes: [Type]
        }

        struct ViewModel {
            let wineViewModel: WineViewModel
            let wineTypes: [WineTypeViewModel]
        }

    }
    
    struct SaveWine {
        
        struct Request {
            let name: String
            let rating: Double
            let type: WineTypeViewModel
            let variety: String
            var location: String?
            var price: Double?
            var notes: String?
            var image: UIImage?
            
            init(name: String, rating: Double, type: WineTypeViewModel, variety: String) {
                self.name = name
                self.rating = rating
                self.type = type
                self.variety = variety
            }
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
}
