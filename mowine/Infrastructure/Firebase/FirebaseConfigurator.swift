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
import FirebaseFirestore
import FirebaseAnalytics
import FirebaseAnalyticsSwift
import GoogleSignIn

/// Responsible for bootstrapping Firebase services at app launch.
class FirebaseConfigurator: Configurator {
    let useEmulator: Bool

    init(useEmulator: Bool = false) {
        self.useEmulator = useEmulator
    }
    
    func configure() {

        FirebaseApp.configure()

        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent("app_configred", parameters: [:])

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        // Use local emulator for UI testing
        if useEmulator {
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings

            Auth.auth().useEmulator(withHost: "localhost", port: 9099)

            // Make sure every test starts signed out
            try! Auth.auth().signOut()
        }
    }
}
