//
//  SignUpView.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    var onSignUp: () -> Void
    
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    EmailSignUpView(onSignUp: onSignUp)
                    FancyDivider(text: "OR")
                    SocialAuthView(isSigningIn: $isLoading, onLogIn: onSignUp)
                    Spacer()
                }
                .padding()
                .navigationTitle("Sign Up")
                .navigationBarItems(leading: Button("Cancel") { onSignUp() })
            }
        }
        .accentColor(Color("Primary Light"))
        .loading(isShowing: isLoading, text: "Signing in...")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView() { }
            .environmentObject(EmailSignUpViewModel(worker: SignUpWorker(emailAuthService: FakeEmailAuth(), userRepository: FakeUserRepository(), session: FakeSession())))
        .environmentObject(SocialAuthViewModel(firstTimeWorker: FirstTimeWorker(workers: [:]), socialSignInMethods: [:]))
    }
}
