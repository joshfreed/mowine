//
//  StringIdentity.swift
//  mowine
//
//  Created by Josh Freed on 11/3/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

class StringIdentity: Hashable, CustomStringConvertible {
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(identityId)
    }

    static func ==(lhs: StringIdentity, rhs: StringIdentity) -> Bool {
        return lhs.identityId == rhs.identityId
    }
}
