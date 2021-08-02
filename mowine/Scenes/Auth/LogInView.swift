//
//  LogInView.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct LogInView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    EmailLogInView()
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot your password?")
                            .foregroundColor(Color("Primary Light"))
                    }
                    FancyDivider(text: "OR")
                    SocialAuthView(isSigningIn: $isLoading)
                    Spacer()
                }
                .padding()
                .navigationTitle("Log In")
                .navigationBarItems(leading: Button("Cancel") { dismiss() })
            }
        }
        .accentColor(.mwSecondary)
        .loading(isShowing: isLoading, text: "Signing in...")
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
