//
//  UserRepository.swift
//  mowine
//
//  Created by Josh Freed on 3/6/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

protocol UserRepository {
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ())
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ())
}
