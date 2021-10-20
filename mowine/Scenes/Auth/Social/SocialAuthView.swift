//
//  SocialAuthView.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct SocialAuthView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isSigningIn: Bool
    @StateObject var vm = SocialAuthViewModel()
    
    var body: some View {
        SocialLoginProviderView() { type in
            Task {
                await vm.socialSignIn(type: type)
                dismiss()
            }
        }        
        .alert(isPresented: $vm.isSignInError) {
            Alert(title: Text("Login Error"), message: Text(vm.signInError))
        }
        .onChange(of: vm.isSigningIn) { isSigningIn = $0 }
    }
}

struct SocialAuthView_Previews: PreviewProvider {
    static var previews: some View {
        SocialAuthView(isSigningIn: .constant(false))
            .padding()
    }
}
