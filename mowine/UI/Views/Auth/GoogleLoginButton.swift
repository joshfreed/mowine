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
        Button(action: action, label: {
            Text("Continue with Google")
                .font(.system(size: 21))
                .fontWeight(.light)
                .foregroundColor(.white)
        })
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: height)
        .background(Color("Brand Google"))
        .cornerRadius(5)
    }
}

struct GoogleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLoginButton(height: 64)
    }
}
