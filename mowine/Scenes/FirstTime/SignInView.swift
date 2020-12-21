//
//  SignInView.swift
//  mowine
//
//  Created by Josh Freed on 12/19/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var vm: SignInViewModel
    
    var body: some View {
        VStack {
            SignInHeaderView()
                .edgesIgnoringSafeArea(.top)
            
            Spacer()
            
            LoginProviderView() {
                vm.continueWith($0)
            }
            .padding([.leading, .trailing])
            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                Button(action: {
                    vm.signInWithEmail()
                }) {
                    Text("Sign in now!").foregroundColor(Color("Primary Light"))
                }
            }
            .padding(.bottom)
        }
        .loading(isShowing: vm.isSigningIn, text: "Signing in...")
        .alert(isPresented: $vm.isSignInError) {
            Alert(title: Text("Login Error"), message: Text(vm.signInError))
        }
    }
}

struct SignInHeaderView: View {
    var body: some View {
        VStack {
            Text("i want")
                .foregroundColor(.white)
                .font(.custom("Snell Roundhand", size: 37))
            Text("mo' wine")
                .foregroundColor(.white)
                .font(.system(size: 50))
                .fontWeight(.black)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.top, 100)
        .padding(.bottom, 64)
        .background(Color("Primary"))
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(vm: SignInViewModel(firstTimeWorker: FirstTimeWorker(workers: [:])))
    }
}
