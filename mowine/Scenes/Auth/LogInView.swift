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
                    SocialAuthView(onLogIn: onLogIn)
                    Spacer()
                }
                .padding()
                .navigationTitle("Log In")
            }
        }
        .accentColor(.mwSecondary)
    }
}

struct LogInView_Previews: PreviewProvider {
    struct ShimView: View {
        init() {
            let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        var body: some View {
            LogInView() { }
        }
    }
    static var previews: some View {
        ShimView()
            .environmentObject(EmailLogInViewModel(emailAuth: FakeEmailAuth()))
            .environmentObject(SocialAuthViewModel(firstTimeWorker: FirstTimeWorker(workers: [:])))
    }
}
