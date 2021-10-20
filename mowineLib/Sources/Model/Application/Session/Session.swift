//
//  Session.swift
//  mowine
//
//  Created by Josh Freed on 2/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import MoWine_Domain

public enum SessionError: Error {
    case notLoggedIn
    case requiresRecentLogin
}

public protocol Session {
    /// Returns the id of the currently logged in user.
    var currentUserId: UserId? { get }

    /// Returns whether the current session is an anonymous user
    var isAnonymous: Bool { get }
    
    var currentUserIdPublisher: AnyPublisher<UserId?, Never> { get }
    
    var authStateDidChange: AnyPublisher<AuthState, Never> { get }
    
    /// Begins a session. It will attempt to resume a previously authenticated session if a user logged in previously. Otherwise it will start a new anonymous session.
    func start()

    /// Begins an anonymous session
    func startAnonymous() async throws
    
    /// Ends the current session.
    func end()
    
    /// Retrieves the auth details of the currently logged in user.
    func getCurrentAuth() -> MoWineAuth?
    
    /// Sets the photo of the current user.
    func setPhotoUrl(_ url: URL, completion: @escaping (Swift.Result<Void, Error>) -> ())
    
    /// Retrievs the URL of the photo for the current user.
    func getPhotoUrl() -> URL?
    
    /// Reauthenticates by email & password so that the auth information can be updated.
    func reauthenticate(withEmail email: String, password: String) async throws
    
    /// Changes the user's login email address.
    func updateEmailAddress(_ emailAddress: String) async throws
}

public struct AuthState: Equatable {
    public let userId: UserId?
    public let isAnonymous: Bool

    public init() {
        userId = nil
        isAnonymous = false
    }

    public init(userId: UserId?, isAnonymous: Bool) {
        self.userId = userId
        self.isAnonymous = isAnonymous
    }
}

public protocol MoWineAuth {
    var email: String? { get }
}
