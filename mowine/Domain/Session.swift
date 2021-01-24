//
//  Session.swift
//  mowine
//
//  Created by Josh Freed on 2/26/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import PromiseKit
import Combine
import SwiftyBeaver

enum SessionError: Error {
    case notLoggedIn
    case requiresRecentLogin
}

protocol Session {
    /// Returns the id of the currently logged in user.
    var currentUserId: UserId? { get }
    
    var isAnonymous: Bool { get }
    
    var currentUserIdPublisher: AnyPublisher<UserId?, Never> { get }
    
    var authStateDidChange: AnyPublisher<Void, Never> { get }
    
    /// Begins a session. It will attempt to resume a previously authenticated session if a user logged in previously. Otherwise it will start a new anonymous session.
    func start(completion: @escaping (Swift.Result<Void, Error>) -> Void)
    
    /// Ends the current session.
    func end()
    
    /// Retrieves the auth details of the currently logged in user.
    func getCurrentAuth() -> MoWineAuth?
    
    /// Sets the photo of the current user.
    func setPhotoUrl(_ url: URL, completion: @escaping (Swift.Result<Void, Error>) -> ())
    
    /// Retrievs the URL of the photo for the current user.
    func getPhotoUrl() -> URL?
    
    /// Reauthenticates by email & password so that the auth information can be updated.
    func reauthenticate(withEmail email: String, password: String, completion: @escaping (Swift.Result<Void, Error>) -> ())
    
    /// Changes the user's login email address.
    func updateEmailAddress(_ emailAddress: String) -> Promise<Void>
}

protocol MoWineAuth {
    var email: String? { get }
}

class ObservableSession: ObservableObject {
    @Published var isAnonymous: Bool
    
    let session: Session
    private var cancellable: AnyCancellable?
    
    init(session: Session) {
        SwiftyBeaver.debug("init")
        
        self.session = session
        self.isAnonymous = session.isAnonymous
        
        observe()
    }
    
    private func observe() {
        let publisher1 = session.authStateDidChange.map { _ in true }
        let publisher2 = NotificationCenter.default.publisher(for: .signedIn).map { _ in true }
        
        cancellable = publisher1.merge(with: publisher2).sink { [weak self] _ in
            guard let strongSelf = self else {
                SwiftyBeaver.warning("authStateDidChange weak self is nil")
                return
            }
            strongSelf.isAnonymous = strongSelf.session.isAnonymous
            SwiftyBeaver.info("authStateDidChange isAnonymous: \(strongSelf.isAnonymous)")
        }
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
    }
    
    func didLogIn() {
        isAnonymous = false
    }
    
    func didLogOut() {
        isAnonymous = true
    }
}
