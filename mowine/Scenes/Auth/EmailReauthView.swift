//
//  EmailReauthView.swift
//  mowine
//
//  Created by Josh Freed on 12/6/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct EmailReauthView: View {
    @StateObject var vm = EmailReauthViewModel()
    var onSuccess: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ReadOnlyEmailView(emailAddress: vm.emailAddress)
            
            FancySecureField(title: "Password", text: $vm.password)

            ErrorLabel(vm.error)
            
            PrimaryButton(
                action: {
                    Task {
                        await vm.reauthenticate()
                        onSuccess()
                    }
                },
                title: "Sign In",
                isLoading: $vm.isReauthenticating
            )
            
            Spacer()
        }
        .padding(16)
        .onAppear {
            vm.loadEmail()
        }
    }
}

struct ReadOnlyEmailView: View {
    let emailAddress: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Email")
                .font(.system(size: 12))
                .foregroundColor(Color("Text Label"))
            Text(emailAddress)
        }
    }
}

struct EmailReauthView_Previews: PreviewProvider {
    static var previews: some View {
        EmailReauthView(vm: .make(password: "testing123", error: "Something went wrong!"), onSuccess: {})
    }
}
