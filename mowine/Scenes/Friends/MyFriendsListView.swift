//
//  MyFriendsListView.swift
//  mowine
//
//  Created by Josh Freed on 2/17/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct MyFriendsListView: View {
    @EnvironmentObject var friends: FriendsService

    var body: some View {
        List(friends.friends) { friend in
            NavigationLink(destination: UserProfileView(userId: friend.id)) {                
                FriendListItemView(name: friend.name, thumbnail: friend.profilePictureUrl)
            }
        }
        .listStyle(.plain)
        .onAppear {
            friends.getMyFriends()
        }
    }
}

struct MyFriendsListView_Previews: PreviewProvider {
    struct ShimView: View {
        @StateObject private var friends: FriendsService = .make()

        var body: some View {
            MyFriendsListView().environmentObject(friends)
        }
    }
    
    static var previews: some View {
        ShimView()
    }
}
