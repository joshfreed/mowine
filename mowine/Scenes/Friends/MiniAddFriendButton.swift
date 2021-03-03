//
//  MiniAddFriendButton.swift
//  mowine
//
//  Created by Josh Freed on 2/26/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct MiniAddFriendButton: View {
    @EnvironmentObject var friends: FriendsService
    let userId: String
    
    var body: some View {
        if !friends.isFriends(with: userId) {
            Button(action: { friends.addFriend(userId) }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color("Primary Light"))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct MiniAddFriendButton_Previews: PreviewProvider {
    static var previews: some View {
        MiniAddFriendButton(userId: "ABC")
            .environmentObject(FriendsService.make())
    }
}
