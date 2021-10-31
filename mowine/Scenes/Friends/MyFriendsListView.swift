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
    @EnvironmentObject var myFriends: MyFriends
    @State private var showUserProfile = false
    @State private var selectedUserId: String = ""

    var body: some View {
        VStack {
            List(myFriends.friends) { friend in
                FriendListItemView(name: friend.name, thumbnail: friend.profilePictureUrl)
                    .onTapGesture {
                        selectedUserId = friend.id
                        showUserProfile = true
                    }
            }
            .listStyle(.plain)
            .accessibilityIdentifier("My Friends List")

            NavigationLink(destination: UserProfileView(userId: selectedUserId), isActive: $showUserProfile) {
                EmptyView()
            }
        }
    }
}

struct MyFriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        MyFriendsListView()
            .environmentObject(MyFriends.fake())
    }
}
