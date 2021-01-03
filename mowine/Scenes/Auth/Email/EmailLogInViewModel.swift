//
//  EmailLogInViewModel.swift
//  mowine
//
//  Created by Josh Freed on 1/2/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver

class EmailLogInViewModel: ObservableObject {
    @Published var isLoggingIn = false
    @Published var error: String = ""
    
    let emailAuth: EmailAuthenticationService
    
    init(emailAuth: EmailAuthenticationService) {
        self.emailAuth = emailAuth
    }
    
    func logIn(emailAddress: String, password: String, onLogIn: @escaping () -> Void) {
        error = ""
        
        guard !emailAddress.isEmpty, !password.isEmpty else {
            return
        }
        
        isLoggingIn = true
        
        emailAuth.signIn(emailAddress: emailAddress, password: password) { [weak self] result in
            self?.isLoggingIn = false
            
            switch result {
            case .success:
                onLogIn()
                NotificationCenter.default.post(name: .signedIn, object: nil)
            case .failure(let error):
                switch error {
                case
                    EmailAuthenticationErrors.userNotFound,
                    EmailAuthenticationErrors.notAuthorized:
                    self?.error = "Login failed. Please check your email and password and try again."
                default:
                    self?.error = "An error occurred while trying to log you in. Please try again in a few minutes."
                }
            }
        }
    }
}
