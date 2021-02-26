//
//  User.swift
//  mowine
//
//  Created by Josh Freed on 3/1/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

typealias UserId = StringIdentity

struct User: Identifiable, Hashable {
    let id: UserId
    var emailAddress: String
    var fullName: String = ""
    var profilePictureUrl: URL?    
}
