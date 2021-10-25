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
    @State private var showUserProfile = false
    @State private var selectedUserId: String = ""

    var body: some View {
        VStack {
            List(friends.friends) { friend in
                FriendListItemView(name: friend.name, thumbnail: friend.profilePictureUrl)
                    .onTapGesture {
                        selectedUserId = friend.id
                        showUserProfile = true
                    }
            }
            .listStyle(.plain)
            .accessibilityIdentifier("My Friends List")
            .onAppear {
                friends.getMyFriends()
            }

            NavigationLink(destination: UserProfileView(userId: selectedUserId), isActive: $showUserProfile) {
                EmptyView()
            }
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
