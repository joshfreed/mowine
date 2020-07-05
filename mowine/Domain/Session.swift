//
//  Session.swift
//  mowine
//
//  Created by Josh Freed on 2/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import PromiseKit

enum SessionError: Error {
    case notLoggedIn
    case requiresRecentLogin
}

protocol Session {
    var isLoggedIn: Bool { get }
    var currentUserId: UserId? { get }
    func end()
    func getCurrentAuth() -> MoWineAuth?
    func reauthenticate(withEmail email: String, password: String, completion: @escaping (Swift.Result<Void, Error>) -> ())
    func setPhotoUrl(_ url: URL, completion: @escaping (EmptyResult) -> ())
    func getPhotoUrl() -> URL?
    func updateEmailAddress(_ emailAddress: String) -> Promise<Void>
}

protocol MoWineAuth {
    var email: String? { get }
}
