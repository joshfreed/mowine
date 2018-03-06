//
//  User.swift
//  mowine
//
//  Created by Josh Freed on 3/1/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit

struct User {
    let id: UserId
    var firstName: String?
    var lastName: String?
    var emailAddress: String
    var profilePicture: UIImage?
    
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
    
    init(id: UserId, emailAddress: String) {
        self.id = id
        self.emailAddress = emailAddress
    }
    
    init(id: UserId, emailAddress: String, firstName: String, lastName: String) {
        self.id = id
        self.emailAddress = emailAddress
        self.firstName = firstName
        self.lastName = lastName
    }
}

protocol UserId {
    
}

class UUIDUserId: UserId {
    let uuid: UUID

    init() {
        uuid = UUID()
    }
    
    init(uuid: UUID) {
        self.uuid = uuid
    }
}

extension UUIDUserId: Hashable {
    var hashValue: Int {
        return uuid.hashValue
    }
    
    static func ==(lhs: UUIDUserId, rhs: UUIDUserId) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
