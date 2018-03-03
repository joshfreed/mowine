//
//  SignInModels.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum SignIn {
    // MARK: Use cases

    enum SignIn {
        struct Request {
            var email: String
            var password: String
        }

        struct Response {
            var isLoggedIn: Bool
            var error: Error?
        }

        struct ViewModel {
            var isLoggedIn: Bool
            var error: Error?
        }
    }
}