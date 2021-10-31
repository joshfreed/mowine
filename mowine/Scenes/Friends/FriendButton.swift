//
//  FriendButton.swift
//  mowine
//
//  Created by Josh Freed on 2/27/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct FriendButton: View {
    @EnvironmentObject var friends: MyFriends
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
                    .destructive(Text("Remove Friend")) { removeFriend(userId) },
                    .cancel()
                ])
            })
                .accessibilityIdentifier("FriendButton")
        } else {
            Button(action: { addFriend(userId) }) {
                Text("Add Friend")
                    .font(.system(size: 12))
                    .foregroundColor(Color("Primary Light"))
                    .frame(width: 80, height: 22)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color("Primary Light")))
            }
            .accessibilityIdentifier("FriendButton")
        }
    }

    func addFriend(_ userId: String) {
        Task {
            do {
                try await friends.addFriend(userId)
            } catch {
                CrashReporter.shared.record(error: error)
            }
        }
    }

    func removeFriend(_ userId: String) {
        Task {
            do {
                try await friends.removeFriend(userId)
            } catch {
                CrashReporter.shared.record(error: error)
            }
        }
    }
}

struct FriendButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FriendButton(userId: "4").previewLayout(.sizeThatFits)
            FriendButton(userId: "1").previewLayout(.sizeThatFits)
        }
        .environmentObject(MyFriends.fake())
    }
}
