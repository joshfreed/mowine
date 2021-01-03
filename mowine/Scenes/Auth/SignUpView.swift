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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                EmailSignUpView(onSignUp: onSignUp)
                FancyDivider(text: "OR")
                SocialAuthView(onLogIn: onSignUp)
                Spacer()
            }
                .padding()
                .navigationTitle("Sign Up")
        }
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
            .environmentObject(SocialAuthViewModel(firstTimeWorker: FirstTimeWorker(workers: [:])))
    }
}
