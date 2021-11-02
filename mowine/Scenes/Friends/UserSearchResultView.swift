//
//  UserSearchResultView.swift
//  mowine
//
//  Created by Josh Freed on 2/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct UserSearchResultView: View {
    let user: SearchUsersResponse.User
    
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
    static var user1 = SearchUsersResponse.User(id: "1", email: "test@test.com", fullName: "Test Guy", profilePictureUrl: nil)
    static var user4 = SearchUsersResponse.User(id: "4", email: "test@test.com", fullName: "Friendly Friend", profilePictureUrl: nil)

    static var previews: some View {
        UserSearchResultView(user: user1)
            .previewLayout(.sizeThatFits)
            .environmentObject(MyFriends.fake())

        UserSearchResultView(user: user4)
            .previewLayout(.sizeThatFits)
            .environmentObject(MyFriends.fake())
    }
}
