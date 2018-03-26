//
//  FirstTimeModels.swift
//  mowine
//
//  Created by Josh Freed on 3/20/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum FirstTime {
    // MARK: Use cases

    enum FacebookLogin {
        struct Request {
        }

        struct Response {
            var error: Error?
        }

        struct ViewModel {
            var error: Error?
        }
    }
}
