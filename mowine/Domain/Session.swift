//
//  Session.swift
//  mowine
//
//  Created by Josh Freed on 2/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

enum SessionError: Error {
    case notLoggedIn
}

protocol Session {
    var isLoggedIn: Bool { get }
    var currentUserId: UserId? { get }
    func end()
    func setPhotoUrl(_ url: URL, completion: @escaping (EmptyResult) -> ())
    func getPhotoUrl() -> URL?
}
