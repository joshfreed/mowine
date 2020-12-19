//
//  FirebaseConfigurator.swift
//  mowine
//
//  Created by Josh Freed on 12/13/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

/// Responsible for bootstrapping Firebase services at app launch.
class FirebaseConfigurator: Configurator {
    func configure() {
        FirebaseApp.configure()

        #if DEBUG
        Analytics.setAnalyticsCollectionEnabled(false)
        #else
        Analytics.setAnalyticsCollectionEnabled(true)
        #endif
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
}
