//
//  ForgotPasswordView.swift
//  mowine
//
//  Created by Josh Freed on 1/2/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import Model
import FirebaseCrashlytics

enum ForgotPasswordAlert: Identifiable {
    case success
    case failure
    
    var id: Int {
        hashValue
    }
}

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @Injected var emailAuth: EmailAuthApplicationService
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
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .fancyField(title: "Email Address", text: $emailAddress)
                .padding(.bottom, 4)
            
            PrimaryButton(action: {
                Task {
                    await sendInstructions()
                }
            }, title: "Send Instructions", isLoading: $isSending)
            
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
    
    private func sendInstructions() async {
        guard !emailAddress.isEmpty else { return }
        
        isSending = true

        do {
            try await emailAuth.forgotPassword(emailAddress: emailAddress)
            activeAlert = .success
        } catch {
            SwiftyBeaver.error("\(error)")
            activeAlert = .failure
        }

        isSending = false
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
