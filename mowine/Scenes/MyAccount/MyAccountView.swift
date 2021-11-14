//
//  MyAccountView.swift
//  mowine
//
//  Created by Josh Freed on 11/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct MyAccountView: View {
    @EnvironmentObject var myAccount: MyAccount
    @Injected private var signOutCommand: SignOutCommand

    @State private var editProfile = false
    @State private var isShowingSignOutConfirmation: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            
            UserPhotoView(photo: myAccount.profilePicture, size: 128)
            
            Color.clear.frame(height: 0)
            
            Text(myAccount.fullName)
                .font(.system(size: 28))
                .fontWeight(.black)
                .accessibility(identifier: "fullName")
            Text(myAccount.emailAddress)
                .font(.system(size: 17))
                .accessibility(identifier: "emailAddress")
            
            Color.clear.frame(height: 48)
            
            Button(action: {
                editProfile = true
            }) {
                Text("Edit Profile")
                    .font(.system(size: 21))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Primary Light"))
                    .frame(height: 38)
            }
            .sheet(isPresented: $editProfile) {
                EditProfileView()
            }
            
            /*
            Button(action: {}) {
                Text("Change Password")
                    .font(.system(size: 21))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Primary Light"))
                    .frame(height: 38)
            }.disabled(!viewModel.isLoaded)
            */
            
            Button(action: {
                isShowingSignOutConfirmation.toggle()
            }) {
                Text("Sign Out")
                    .font(.system(size: 21))
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                    .frame(height: 38)
            }
            .accessibility(identifier: "signOutButton")
            .actionSheet(isPresented: $isShowingSignOutConfirmation, content: {
                ActionSheet(title: Text("Are you sure?"), message: nil, buttons: [
                    .destructive(Text("Sign Out"), action: {
                        signOutCommand.signOut()
                    }),
                    .cancel()
                ])
            })
            
            Color.clear.frame(height: 8)
        }
        .analyticsScreen(name: "My Account", class: "MyAccountView")
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
            .environmentObject(MyAccount.fake())
    }
}
