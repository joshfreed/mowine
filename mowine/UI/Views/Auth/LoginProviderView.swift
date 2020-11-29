//
//  LoginProviderView.swift
//  mowine
//
//  Created by Josh Freed on 11/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct LoginProviderView: View {
    var body: some View {
        VStack {
            FacebookLoginButton()
            GoogleLoginButton()
            EmailLoginButton()
        }
    }
}

struct LoginProviderView_Previews: PreviewProvider {
    static var previews: some View {
        LoginProviderView()
    }
}
