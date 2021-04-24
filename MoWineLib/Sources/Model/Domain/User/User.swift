//
//  User.swift
//  mowine
//
//  Created by Josh Freed on 3/1/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

public typealias UserId = StringIdentity

public struct User: Identifiable, Hashable {
    public let id: UserId
    public var emailAddress: String
    public var fullName: String = ""
    public var profilePictureUrl: URL?

    public init(id: UserId, emailAddress: String) {
        self.id = id
        self.emailAddress = emailAddress
    }
}
