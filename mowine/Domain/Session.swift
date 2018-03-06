//
//  Session.swift
//  mowine
//
//  Created by Josh Freed on 2/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

protocol Session {
    var isLoggedIn: Bool { get }
    var currentUserId: UserId? { get }
    func resume()
    func getCurrentUser(completion: @escaping (Result<User>) -> ())
}
