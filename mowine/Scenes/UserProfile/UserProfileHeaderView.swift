//
//  UserProfileHeaderView.swift
//  mowine
//
//  Created by Josh Freed on 2/27/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct UserProfileHeaderView: View {
    @ObservedObject var vm: UserProfileHeaderViewModel
    
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
        .background(Color(.mwPrimary))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("User Profile Header")
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let vm: UserProfileHeaderViewModel = {
        var vm = UserProfileHeaderViewModel()
        vm.fullName = "Barry Jones"
        return vm
    }()

    UserProfileHeaderView(vm: vm)
        .addPreviewEnvironment()
        .addPreviewData()
}
