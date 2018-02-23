//
//  SelectTypeModels.swift
//  mowine
//
//  Created by Josh Freed on 7/4/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum SelectType {
    // MARK: Use cases

    enum SelectType {
        struct Request {
            var type: String
        }
        
        struct Response {
            var type: WineType
        }
        
        struct ViewModel {
            var hasVarieties: Bool
        }
    }
    
}
