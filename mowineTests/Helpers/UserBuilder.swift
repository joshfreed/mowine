//
//  UserBuilder.swift
//  mowineTests
//
//  Created by Josh Freed on 3/7/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
@testable import mowine

class UserBuilder {
    var userId: UserId?
    var emailAddress: String?
    
    static func aUser() -> UserBuilder {
        return UserBuilder()
    }
    
    func build() -> User {
        if userId == nil {
            userId = UserId()
        }
        if emailAddress == nil {
            emailAddress = "barry@test.com"
        }
        
        var user = User(id: userId!, emailAddress: emailAddress!)
        return user
    }
    
    func withEmail(_ email: String) -> UserBuilder {
        emailAddress = email
        return self
    }
}
