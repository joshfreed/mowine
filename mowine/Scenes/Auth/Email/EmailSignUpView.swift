//
//  EmailSignUpView.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct EmailSignUpView: View {
    var onSignUp: () -> Void
    @StateObject var vm = EmailSignUpViewModel()
    @State var emailAddress: String = ""
    @State var fullName: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("", text: $fullName)
                .accessibility(identifier: "fullName")
                .fancyField(title: "Full Name", text: $fullName)
                .padding(.bottom, 4)
            
            TextField("", text: $emailAddress)
                .accessibility(identifier: "email")
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .fancyField(title: "Email Address", text: $emailAddress)
                .padding(.bottom, 4)
            
            SecureField("", text: $password)
                .accessibility(identifier: "password")
                .fancyField(title: "Password", text: $password)
                .padding(.bottom, 4)
            
            ErrorLabel(vm.errorMessage)
            
            PrimaryButton(action: {
                vm.signUp(fullName: fullName, emailAddress: emailAddress, password: password, onSignUp: onSignUp)
            }, title: "Sign Up", isLoading: $vm.isLoading)
                .accessibility(identifier: "signUp")
        }
    }
}

struct EmailSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignUpView() { }
            .padding()
    }
}
