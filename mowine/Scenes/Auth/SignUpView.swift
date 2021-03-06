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
    struct ShimView: View {
        init() {
            let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        var body: some View {
            SignUpView() { }
        }
    }

    static var previews: some View {
        ShimView()
            .environmentObject(EmailSignUpViewModel(worker: SignUpWorker(emailAuthService: FakeEmailAuth(), userRepository: FakeUserRepository(), session: FakeSession())))
        .environmentObject(SocialAuthViewModel(firstTimeWorker: FirstTimeWorker(workers: [:]), socialSignInMethods: [:]))
    }
}
