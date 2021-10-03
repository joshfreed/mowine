//
//  UserSearchResultView.swift
//  mowine
//
//  Created by Josh Freed on 2/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct UserSearchResultView: View {
    let user: UsersService.UserSearchResult
    
    var body: some View {
        HStack(spacing: 8) {
            UserPhotoView(photo: .url(user.profilePictureUrl))
            
            Text(user.fullName)
                .font(.system(size: 21))
            
            Spacer()

            MiniAddFriendButton(userId: user.id)
        }
    }
}

struct UserSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchResultView(
            user: .init(id: "1", email: "test@test.com", fullName: "Test Guy", profilePictureUrl: nil)
        )
            .environmentObject(FriendsService.make())
    }
}
