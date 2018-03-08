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
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

struct UserId: Hashable, CustomStringConvertible {
    private let uuid: UUID
    
    var description: String {
        return uuid.uuidString
    }
    
    init() {
        uuid = UUID()
    }
    
    init(uuid: UUID) {
        self.uuid = uuid
    }
    
    init?(string: String) {
        guard let uuid = UUID(uuidString: string) else {
            return nil
        }
        
        self.init(uuid: uuid)
    }
    
    var hashValue: Int {
        return uuid.hashValue
    }
    
    static func ==(lhs: UserId, rhs: UserId) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
