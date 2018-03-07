//
//  MyAccountWorker.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import JFLib

class MyAccountWorker {
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func getCurrentUser(completion: @escaping (Result<User>) -> ()) {
        session.getCurrentUser(completion: completion)
    }
    
    func signOut() {
        session.end()
    }
}
