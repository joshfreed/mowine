//
//  SignOutCommand.swift
//  mowine
//
//  Created by Josh Freed on 11/25/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import MoWine_Domain

public extension Notification.Name {
    static let signedIn = Notification.Name("signedIn")
    static let signedOut = Notification.Name("signedOut")
}

public class SignOutCommand {
    let session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    public func signOut() {
        session.end()
        NotificationCenter.default.post(name: .signedOut, object: nil, userInfo: nil)        
    }
}
