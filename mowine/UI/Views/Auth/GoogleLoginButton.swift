//
//  GoogleLoginButton.swift
//  mowine
//
//  Created by Josh Freed on 11/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct GoogleLoginButton: View {
    var height: CGFloat
    var action: () -> Void = { }
    
    var body: some View {
        PrimaryButton(
            action: action,
            title: "Continue with Google",
            isLoading: .constant(false),
            height: height,
            backgroundColor: Color("Brand Google")
        )
    }
}

struct GoogleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLoginButton(height: 64)
    }
}
