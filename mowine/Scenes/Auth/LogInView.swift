//
//  LogInView.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct LogInView: View {
    var onLogIn: () -> Void
    
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    EmailLogInView(onLogIn: onLogIn)
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot your password?")
                            .foregroundColor(Color("Primary Light"))
                    }
                    FancyDivider(text: "OR")
                    SocialAuthView(isSigningIn: $isLoading, onLogIn: onLogIn)
                    Spacer()
                }
                .padding()
                .navigationTitle("Log In")
                .navigationBarItems(leading: Button("Cancel") { onLogIn() })
            }
        }
        .accentColor(.mwSecondary)
        .loading(isShowing: isLoading, text: "Signing in...")
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView() { }
            .environmentObject(EmailLogInViewModel(emailAuth: FakeEmailAuth()))
            .environmentObject(SocialAuthViewModel(firstTimeWorker: FirstTimeWorker(workers: [:]), socialSignInMethods: [:]))
    }
}
