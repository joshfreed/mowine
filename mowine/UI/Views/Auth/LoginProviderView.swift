//
//  LoginProviderView.swift
//  mowine
//
//  Created by Josh Freed on 11/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct LoginProviderView: View {
    let onSelect: (ReauthenticationViewModel.LoginType) -> Void
    
    var body: some View {
        VStack {
            FacebookLoginButton() { onSelect(.facebook) }
            GoogleLoginButton() { onSelect(.google) }
            EmailLoginButton() { onSelect(.email) }
        }
    }
}

struct LoginProviderView_Previews: PreviewProvider {
    static var previews: some View {
        LoginProviderView() { _ in }
    }
}
