//
//  UserProfileHeaderView.swift
//  mowine
//
//  Created by Josh Freed on 2/27/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct UserProfileHeaderView: View {
    let userId: String
    @StateObject var vm = UserProfileHeaderViewModel()
    
    var body: some View {
        VStack(spacing: 8) {
            UserPhotoView(photo: .url(vm.profilePicture), size: 64)
            Text(vm.fullName)
                .font(.system(size: 28))
                .fontWeight(.black)
                .foregroundColor(.white)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color("Primary"))
        .task {
            await vm.load(userId: userId)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("User Profile Header")
    }
}

struct UserProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileHeaderView(userId: "U1")
            .addPreviewEnvironment()
            .addPreviewData()
    }
}
