//
//  FriendButton.swift
//  mowine
//
//  Created by Josh Freed on 2/27/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct FriendButton: View {
    @EnvironmentObject var friends: FriendsService
    let userId: String
    
    @State private var showUnfriendConfirmation = false
    
    var body: some View {
        if friends.isFriends(with: userId) {
            Button(action: { showUnfriendConfirmation = true }) {
                Text("Friends")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 22)
                    .background(Color("Primary Light"))
                    .cornerRadius(5)
            }.actionSheet(isPresented: $showUnfriendConfirmation, content: {
                ActionSheet(title: Text("You are currently friends."), buttons: [
                    .destructive(Text("Remove Friend")) { friends.removeFriend(userId) },
                    .cancel()
                ])
            })
        } else {
            Button(action: { friends.addFriend(userId) }) {
                Text("Add Friend")
                    .font(.system(size: 12))
                    .foregroundColor(Color("Primary Light"))
                    .frame(width: 80, height: 22)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("Primary Light")))
            }
        }
    }
}

struct FriendButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FriendButton(userId: "4").previewLayout(.sizeThatFits)
            FriendButton(userId: "1").previewLayout(.sizeThatFits)
        }.environmentObject(FriendsService.make())
    }
}
