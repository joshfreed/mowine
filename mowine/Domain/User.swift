//
//  User.swift
//  mowine
//
//  Created by Josh Freed on 3/1/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

struct User: Equatable {
    let id: UserId
    var emailAddress: String
    var firstName: String?
    var lastName: String?
    var profilePicture: UIImage?
    var isFriend: Bool = false
    
    var fullName: String {
        let firstName = self.firstName ?? ""
        let lastName = self.lastName ?? ""
        
        var _fullName = firstName
        if !_fullName.isEmpty {
            _fullName += " "
        }
        _fullName += lastName
        return _fullName
    }
    
    init(emailAddress: String) {
        self.id = UserId()
        self.emailAddress = emailAddress
    }
    
    init(id: UserId, emailAddress: String) {
        self.id = id
        self.emailAddress = emailAddress
    }

    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.emailAddress == rhs.emailAddress
    }
}

struct UserId: Hashable, CustomStringConvertible {
    let identityId: String
    
    var description: String {
        return identityId
    }
    
    var asString: String {
        return description
    }
    
    init() {
        identityId = UUID().uuidString
    }
    
    init(string: String) {
        identityId = string
    }
    
    var hashValue: Int {
        return identityId.hashValue
    }
    
    static func ==(lhs: UserId, rhs: UserId) -> Bool {
        return lhs.identityId == rhs.identityId
    }
}
