//
//  RateWineModels.swift
//  mowine
//
//  Created by Josh Freed on 9/20/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum RateWine {
    // MARK: Use cases

    enum GetWine {

        struct Request {
        }

        struct Response {
            var photo: UIImage?
            var name: String
        }

        struct ViewModel {
            var photo: UIImage?
            var name: String
        }

    }

}
