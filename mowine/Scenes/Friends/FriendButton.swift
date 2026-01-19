//
//  FriendButton.swift
//  mowine
//
//  Created by Josh Freed on 2/27/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application
import OSLog

struct FriendButton: View {
    @EnvironmentObject var friends: MyFriends
    let userId: String
    private let logger = Logger(category: .ui)

    @State private var showUnfriendConfirmation = false
    
    var body: some View {
        if friends.isFriends(with: userId) {
            Button("Friends") {
                showUnfriendConfirmation = true
            }
            .actionSheet(isPresented: $showUnfriendConfirmation, content: {
                ActionSheet(title: Text("You are currently friends."), buttons: [
                    .destructive(Text("Remove Friend")) { removeFriend(userId) },
                    .cancel()
                ])
            })
            .accessibilityIdentifier("FriendButton")
        } else {
            Button("Add Friend") {
                addFriend(userId)
            }
            .accessibilityIdentifier("FriendButton")
        }
    }

    func addFriend(_ userId: String) {
        Task {
            do {
                try await friends.addFriend(userId)
            } catch {
                logger.error("\(error)")
                CrashReporter.shared.record(error: error)
            }
        }
    }

    func removeFriend(_ userId: String) {
        Task {
            do {
                try await friends.removeFriend(userId)
            } catch {
                logger.error("\(error)")
                CrashReporter.shared.record(error: error)
            }
        }
    }
}

#Preview("Not Friends", traits: .sizeThatFitsLayout) {
    FriendButton(userId: "4")
        .environmentObject(MyFriends.fake())
}

#Preview("Friends", traits: .sizeThatFitsLayout) {
    FriendButton(userId: "1")
        .environmentObject(MyFriends.fake())
}
