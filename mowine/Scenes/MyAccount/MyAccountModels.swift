//
//  MyAccountModels.swift
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

enum MyAccount {
    // MARK: Use cases

    enum GetUser {
        struct Request {
        }

        struct Response {
            var user: User
        }

        struct ViewModel {
            var fullName: String
            var emailAddress: String
            var profilePicture: UIImage
        }
    }
}