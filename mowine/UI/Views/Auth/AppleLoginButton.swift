//
//  AppleLoginButton.swift
//  mowine
//
//  Created by Josh Freed on 12/19/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    var height: CGFloat
    var action: () -> Void = { }
    
    var body: some View {
        SignInWithAppleButton()
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: height)
            .onTapGesture(perform: action)
    }
}

struct SignInWithAppleButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .continue, style: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}

struct AppleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginButton(height: 64)
    }
}
