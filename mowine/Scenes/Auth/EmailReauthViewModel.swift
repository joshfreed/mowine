//
//  EmailReauthViewModel.swift
//  mowine
//
//  Created by Josh Freed on 12/6/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Application

class EmailReauthViewModel: ObservableObject {
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var error: String = ""
    @Published var isReauthenticating = false

    @Injected private var session: Session

    func loadEmail() {
        if let auth = session.getCurrentAuth(), let email = auth.email {
            emailAddress = email
        } else {
            // Not logged in
        }
    }

    @MainActor
    func reauthenticate() async {
        isReauthenticating = true
        error = ""

        do {
            try await session.reauthenticate(withEmail: emailAddress, password: password)
        } catch {
            self.error = error.localizedDescription
        }

        isReauthenticating = false
    }
}
