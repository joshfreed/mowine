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
        Button(action: action) {
            Text("Continue with Facebook")
                .font(.system(size: 21))
                .fontWeight(.light)
                .foregroundColor(.white)
                .frame(height: height)
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color("Brand Facebook"))
                .cornerRadius(5)
        }        
    }
}

struct FacebookLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        FacebookLoginButton(height: 64)
    }
}
