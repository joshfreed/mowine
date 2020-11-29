//
//  MyAccountView.swift
//  mowine
//
//  Created by Josh Freed on 11/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyAccountView: View {
    @ObservedObject var viewModel: MyAccountViewModel
    @State var isShowingSignOutConfirmation: Bool = false
    @State var isEditingProfile: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            
            ProfilePictureView2(data: viewModel.profilePicture)
                .frame(width: 128, height: 128)
            
            Color.clear.frame(height: 0)
            
            Text(viewModel.fullName)
                .font(.system(size: 28))
                .fontWeight(.black)
            Text(viewModel.emailAddress)
                .font(.system(size: 17))
            
            Color.clear.frame(height: 48)
            
            Button(action: {
                isEditingProfile = true
            }) {
                Text("Edit Profile")
                    .font(.system(size: 21))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Primary Light"))
                    .frame(height: 38)
            }
            Button(action: {}) {
                Text("Change Password")
                    .font(.system(size: 21))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Primary Light"))
                    .frame(height: 38)
            }
            Button(action: {
                isShowingSignOutConfirmation.toggle()
            }) {
                Text("Sign Out")
                    .font(.system(size: 21))
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                    .frame(height: 38)
            }.actionSheet(isPresented: $isShowingSignOutConfirmation, content: {
                ActionSheet(title: Text("Are you sure?"), message: nil, buttons: [
                    .destructive(Text("Sign Out"), action: {
                        viewModel.signOut()
                    }),
                    .cancel()
                ])
            })
            
            Color.clear.frame(height: 8)
        }.onAppear {
            viewModel.loadMyAccount()
        }.sheet(isPresented: $isEditingProfile, content: {
            EditProfileView(vm: EditProfileViewModel.factory {
                isEditingProfile = false
            })
        })
    }
}

struct ProfilePictureView2: View {
    let data: Data?
    
    var body: some View {
        if let data = data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
        } else {
            Image("No Profile Picture").resizable()
        }
        
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView(viewModel: MyAccountViewModel.make())
    }
}
