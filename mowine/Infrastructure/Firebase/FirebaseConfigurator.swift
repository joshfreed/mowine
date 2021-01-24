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
    let useEmulator: Bool
    
    init(useEmulator: Bool) {
        self.useEmulator = useEmulator
    }
    
    func configure() {
        
        FirebaseApp.configure()

        #if DEBUG
        Analytics.setAnalyticsCollectionEnabled(false)
        #else
        Analytics.setAnalyticsCollectionEnabled(true)
        #endif
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        // Use local emulator for development / testing
        
        #if DEBUG
        if useEmulator {
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings

            Auth.auth().useEmulator(withHost:"localhost", port:9099)
        }
        #endif
    }
}
