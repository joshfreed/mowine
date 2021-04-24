//
//  EmailReauthViewModel.swift
//  mowine
//
//  Created by Josh Freed on 12/6/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import Model

class EmailReauthViewModel: ObservableObject {
    let session: Session
    let onSuccess: () -> Void
    
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var error: String = ""
    @Published var isReauthenticating = false
    
    init(session: Session, onSuccess: @escaping () -> Void) {
        self.session = session
        self.onSuccess = onSuccess
    }
    
    func loadEmail() {
        if let auth = session.getCurrentAuth(), let email = auth.email {
            emailAddress = email
        } else {
            // Not logged in
        }
    }
    
    func reauthenticate() {
        isReauthenticating = true
        error = ""
        
        session.reauthenticate(withEmail: emailAddress, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isReauthenticating = false

                switch result {
                case .success: self?.onSuccess()
                case .failure(let error): self?.error = error.localizedDescription
                }
            }
        }
    }
}
