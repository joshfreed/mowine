//
//  ReauthenticationView.swift
//  mowine
//
//  Created by Josh Freed on 11/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct ReauthenticationView: View {
    @ObservedObject var vm: ReauthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 28) {
                Text("Please reauthenticate in order to continue.")
                
                NavigationLink(destination: EmailReauthView(vm: vm.makeEmailReauthViewModel())) {
                    Text("Continue with Email")
                        .buttonPrimaryOutline()
                }
                
                FancyDivider(text: "OR")
                
                SocialLoginProviderView() {
                    vm.continueWith($0)
                }                
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                vm.cancel()
            })
        }
        .accentColor(.mwSecondary)
        .alert(isPresented: $vm.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(vm.errorMessage))
        }
    }
}

struct ReauthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        ReauthenticationView(vm: ReauthenticationViewModel(onSuccess: {}, onCancel: {}))
    }
}
