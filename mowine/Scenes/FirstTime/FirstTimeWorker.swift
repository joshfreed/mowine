//
//  FirstTimeWorker.swift
//  mowine
//
//  Created by Josh Freed on 3/20/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoogleSignIn
import SwiftyBeaver
import Model

class FirstTimeWorker {
    let workers: [SocialProviderType: SocialSignInWorker]

    init(workers: [SocialProviderType: SocialSignInWorker]) {
        self.workers = workers
    }

    func login(type: SocialProviderType, token: SocialToken) async throws {
        guard let worker = workers[type] else {
            fatalError("No worker for type: \(type)")
        }

        try await worker.login(token: token)
    }
}
