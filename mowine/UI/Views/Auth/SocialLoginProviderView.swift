//
//  SocialLoginProviderView.swift
//  mowine
//
//  Created by Josh Freed on 11/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct SocialLoginProviderView: View {
    let onSelect: (SocialProviderType) -> Void
    let height: CGFloat = 48
    
    var body: some View {
        VStack(spacing: 8) {
            AppleLoginButton(height: height) { onSelect(.apple) }
            FacebookLoginButton(height: height) { onSelect(.facebook) }
            GoogleLoginButton(height: height) { onSelect(.google) }
        }
    }
}

struct SocialLoginProviderView_Previews: PreviewProvider {
    static var previews: some View {
        SocialLoginProviderView() { _ in }
    }
}
