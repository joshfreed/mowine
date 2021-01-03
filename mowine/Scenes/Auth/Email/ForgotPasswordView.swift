//
//  ForgotPasswordView.swift
//  mowine
//
//  Created by Josh Freed on 1/2/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import SwiftyBeaver

enum ForgotPasswordAlert: Identifiable {
    case success
    case failure
    
    var id: Int {
        hashValue
    }
}

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var emailAddress: String = ""
    @State private var isSending = false
    @State private var activeAlert: ForgotPasswordAlert?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Please enter the email address you used to create your account and we'll send you instructions for resetting your password.")
                
                .font(.body)
                .multilineTextAlignment(.center)
            
            TextField("", text: $emailAddress)
                .textContentType(.emailAddress)
                .fancyField(title: "Email Address", text: $emailAddress)
                .padding(.bottom, 4)
            
            PrimaryButton(action: sendInstructions, title: "Send Instructions", isLoading: $isSending, height: 48)
            
            Spacer()
        }
        .navigationTitle("Forgot Password")
        .padding()
        .alert(item: $activeAlert) { item in
            switch item {
            case .success:
                return Alert(
                    title: Text("Email Sent"),
                    message: Text("You should receive a password reset email momentarily. Please check your inbox."),
                    dismissButton: Alert.Button.default(
                        Text("Okay"), action: { presentationMode.wrappedValue.dismiss() }
                    )
                )
            case .failure:
                return Alert(
                    title: Text("Error Sending Email"),
                    message: Text("There was a problem sending the password reset email. Please check your email address and try again.")
                )
            }
        }
    }
    
    private func sendInstructions() {
        guard !emailAddress.isEmpty else { return }
        
        isSending = true
        
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { error in
            self.isSending = false
            
            if let error = error {
                SwiftyBeaver.error("\(error)")
                self.activeAlert = .failure
            } else {
                self.activeAlert = .success
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
