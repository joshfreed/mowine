//
//  SignUpView.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    EmailSignUpView()
                    FancyDivider(text: "OR")
                    SocialAuthView(isSigningIn: $isLoading)
                    Spacer()
                }
                .padding()
                .navigationTitle("Sign Up")
                .navigationBarItems(leading: Button("Cancel") { dismiss() })
            }
        }
        .accentColor(Color("Primary Light"))
        .loading(isShowing: isLoading, text: "Signing in...")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(EmailSignUpViewModel(worker: SignUpWorker(emailAuthService: FakeEmailAuth(), userRepository: FakeUserRepository(), session: FakeSession())))
        .environmentObject(SocialAuthViewModel(firstTimeWorker: FirstTimeWorker(workers: [:]), socialSignInMethods: [:]))
    }
}
