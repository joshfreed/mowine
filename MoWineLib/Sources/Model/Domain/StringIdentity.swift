//
//  StringIdentity.swift
//  mowine
//
//  Created by Josh Freed on 11/3/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

public class StringIdentity: Hashable, CustomStringConvertible {
    let identityId: String
    
    public var description: String {
        return identityId
    }
    
    public var asString: String {
        return description
    }
    
    public init() {
        identityId = UUID().uuidString
    }
    
    public init(string: String) {
        identityId = string
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identityId)
    }

    public static func ==(lhs: StringIdentity, rhs: StringIdentity) -> Bool {
        return lhs.identityId == rhs.identityId
    }
}
