//
//  UserProfileHeaderView.swift
//  mowine
//
//  Created by Josh Freed on 2/27/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct UserProfileHeaderView: View {
    @StateObject var vm: UserProfileHeaderViewModel
    
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
            await vm.load()
        }
    }
}

struct UserProfileHeaderView_Previews: PreviewProvider {
    static var vm: UserProfileHeaderViewModel = {
        var vm = UserProfileHeaderViewModel(userId: "1", users: .make())
        vm.fullName = "Josh Freed"
        return vm
    }()
    
    static var previews: some View {
        UserProfileHeaderView(vm: self.vm)
    }
}
