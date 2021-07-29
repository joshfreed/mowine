//
//  MyAccountView.swift
//  mowine
//
//  Created by Josh Freed on 11/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

enum MyAccountSheet: Identifiable {
    case logIn
    case signUp
    case editProfile
    
    var id: Int {
        hashValue
    }
}

struct MyAccountViewContainer: View {
    @EnvironmentObject var session: ObservableSession

    @State private var activeSheet: MyAccountSheet?
    
    var body: some View {
        let _ = Self._printChanges()
        Group {
            if session.isAnonymous {
                AnonymousUserView() { activeSheet = $0 }
            } else {
                MyAccountView(activeSheet: $activeSheet)
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .logIn: LogInView() { activeSheet = nil }
            case .signUp: SignUpView() { activeSheet = nil }
            case .editProfile: EditProfileView() { activeSheet = nil }
            }
        }
    }
}

struct MyAccountView: View {
    @StateObject var viewModel = MyAccountViewModel()
    @Binding var activeSheet: MyAccountSheet?
    
    @State private var isShowingSignOutConfirmation: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            
            ProfilePictureView2(image: viewModel.profilePicture)
                .frame(width: 128, height: 128)
            
            Color.clear.frame(height: 0)
            
            Text(viewModel.fullName)
                .font(.system(size: 28))
                .fontWeight(.black)
                .accessibility(identifier: "fullName")
            Text(viewModel.emailAddress)
                .font(.system(size: 17))
                .accessibility(identifier: "emailAddress")
            
            Color.clear.frame(height: 48)
            
            Button(action: { activeSheet = .editProfile }) {
                Text("Edit Profile")
                    .font(.system(size: 21))
                    .fontWeight(.medium)
                    .foregroundColor(Color("Primary Light"))
                    .frame(height: 38)
            }.disabled(!viewModel.isLoaded)
            
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
                        viewModel.signOut()
                    }),
                    .cancel()
                ])
            })
            
            Color.clear.frame(height: 8)
        }.onAppear {
            viewModel.loadMyAccount()
        }
    }
}

struct ProfilePictureView2: View {
    let image: UIImage?
    
    var body: some View {
        if let uiImage = image {
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
        MyAccountView(activeSheet: .constant(nil))
            .environmentObject(MyAccountViewModel.make())
    }
}
