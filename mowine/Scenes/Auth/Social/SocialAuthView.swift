//
//  SocialAuthView.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct SocialAuthView: View {
    var onLogIn: () -> Void
    @EnvironmentObject var vm: SocialAuthViewModel
    
    var body: some View {
        SocialLoginProviderView() { type in
            vm.socialSignIn(type: type, onLogIn: onLogIn)
        }
        .alert(isPresented: $vm.isSignInError) {
            Alert(title: Text("Login Error"), message: Text(vm.signInError))
        }
    }
}

struct SocialAuthView_Previews: PreviewProvider {
    static var previews: some View {
        SocialAuthView() { }
            .padding()
            .environmentObject(SocialAuthViewModel(firstTimeWorker: FirstTimeWorker(workers: [:])))
    }
}
