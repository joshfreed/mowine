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

        Analytics.logEvent("app_configred", parameters: [:])

        // Use local emulator for UI testing
        if useEmulator {
            Analytics.logEvent("ui_testing", parameters: [:])

            Auth.auth().useEmulator(withHost: "localhost", port: 9099)

            // Make sure every test starts signed out
            try! Auth.auth().signOut()

            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings

            Storage.storage().useEmulator(withHost: "localhost", port: 9199)
        }
    }
}
