//
//  EmailLoginButton.swift
//  mowine
//
//  Created by Josh Freed on 11/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct EmailLoginButton: View {
    var action: () -> Void = { }
    
    var body: some View {
        Button(action: action, label: {
            Text("Continue with Email")
                .font(.system(size: 21))
                .fontWeight(.light)
                .foregroundColor(Color("Primary"))
        })
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 72)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color("Primary"), lineWidth: 1)
        )
    }
}

struct EmailLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        EmailLoginButton()
    }
}
