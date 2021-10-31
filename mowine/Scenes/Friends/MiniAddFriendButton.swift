//
//  MiniAddFriendButton.swift
//  mowine
//
//  Created by Josh Freed on 2/26/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct MiniAddFriendButton: View {
    @EnvironmentObject var friends: MyFriends
    let userId: String
    
    var body: some View {
        if !friends.isFriends(with: userId) {
            Button(action: { addFriend() }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color("Primary Light"))
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityIdentifier("MiniAddFriendButton")
        }
    }

    func addFriend() {
        Task {
            do {
                try await friends.addFriend(userId)
            } catch {
                CrashReporter.shared.record(error: error)
            }
        }
    }
}

struct MiniAddFriendButton_Previews: PreviewProvider {
    static var previews: some View {
        MiniAddFriendButton(userId: "ABC")
            .previewLayout(.sizeThatFits)
            .environmentObject(MyFriends.fake())
    }
}
