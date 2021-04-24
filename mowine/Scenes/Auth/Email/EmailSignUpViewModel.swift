//
//  EmailSignUpViewModel.swift
//  mowine
//
//  Created by Josh Freed on 1/2/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import Model

class EmailSignUpViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String = ""
    
    private let worker: SignUpWorker
    
    init(worker: SignUpWorker) {
        self.worker = worker
    }
    
    func signUp(fullName: String, emailAddress: String, password: String, onSignUp: @escaping () -> Void) {
        errorMessage = ""
        
        guard !fullName.isEmpty, !emailAddress.isEmpty, !password.isEmpty else {
            return
        }

        isLoading = true        
        
        worker.signUp(emailAddress: emailAddress, password: password, fullName: fullName) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success:
                onSignUp()
                NotificationCenter.default.post(name: .signedIn, object: nil)
            case .failure(let error): self?.displaySignUpError(error)
            }
        }
    }
    
    private func displaySignUpError(_ error: Error) {
        switch error {
        case EmailAuthenticationErrors.invalidPassword(let message):
            errorMessage = message ?? "Invalid password."
        case EmailAuthenticationErrors.emailAddressAlreadyInUse:
            errorMessage = "That email address is already associated with an account. Try signing in or resetting your password."
        default:
            errorMessage = "An error occurred while trying to create your account. Please try again in a few minutes."
        }
    }
}
