//
//  FacebookLoginButton.swift
//  mowine
//
//  Created by Josh Freed on 11/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct FacebookLoginButton: View {
    var height: CGFloat
    var action: () -> Void = { }
    
    var body: some View {
        PrimaryButton(
            action: action,
            title: "Continue with Facebook",
            isLoading: .constant(false),
            height: height,
            backgroundColor: Color("Brand Facebook")
        )
    }
}

struct FacebookLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        FacebookLoginButton(height: 64)
    }
}
