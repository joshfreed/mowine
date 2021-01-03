//
//  EmailLogInView.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct EmailLogInView: View {
    var onLogIn: () -> Void
    @EnvironmentObject var vm: EmailLogInViewModel
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("", text: $emailAddress)
                .fancyField(title: "Email Address", text: $emailAddress)
                .padding(.bottom, 4)
            
            SecureField("", text: $password)
                .fancyField(title: "Password", text: $password)
                .padding(.bottom, 4)
            
            ErrorLabel(vm.error)
            
            PrimaryButton(action: {
                vm.logIn(emailAddress: emailAddress, password: password, onLogIn: onLogIn)
            }, title: "Log In", isLoading: $vm.isLoggingIn, height: 48)
        }
    }
}

struct EmailLogInView_Previews: PreviewProvider {
    static var previews: some View {
        EmailLogInView() { }
            .padding()
            .environmentObject(EmailLogInViewModel(emailAuth: FakeEmailAuth()))
    }
}
