//
//  LoginProviderView.swift
//  mowine
//
//  Created by Josh Freed on 11/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct LoginProviderView: View {
    let onSelect: (LoginType) -> Void
    
    var body: some View {
        VStack {
            FacebookLoginButton(height: 64) { onSelect(.social(.facebook)) }
            GoogleLoginButton(height: 64) { onSelect(.social(.google)) }
            EmailLoginButton(height: 64) { onSelect(.email) }
        }
    }
}

struct LoginProviderView_Previews: PreviewProvider {
    static var previews: some View {
        LoginProviderView() { _ in }
    }
}
