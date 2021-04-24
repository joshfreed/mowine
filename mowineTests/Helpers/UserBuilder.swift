//
//  UserBuilder.swift
//  mowineTests
//
//  Created by Josh Freed on 3/7/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
@testable import mowine
import Model

class UserBuilder {
    private var userId: UserId?
    private var emailAddress: String?
    
    static func aUser() -> UserBuilder {
        return UserBuilder()
    }

    static func aUser(id: UserId) -> UserBuilder {
        return UserBuilder(id: id)
    }

    init() {

    }

    init(id: UserId) {
        userId = id
    }
    
    func build() -> User {
        if userId == nil {
            userId = UserId()
        }
        if emailAddress == nil {
            emailAddress = "barry@test.com"
        }
        
        let user = User(id: userId!, emailAddress: emailAddress!)
        return user
    }
    
    func withEmail(_ email: String) -> UserBuilder {
        emailAddress = email
        return self
    }
}
