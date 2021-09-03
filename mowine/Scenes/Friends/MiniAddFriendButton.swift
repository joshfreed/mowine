//
//  MiniAddFriendButton.swift
//  mowine
//
//  Created by Josh Freed on 2/26/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model
import FirebaseCrashlytics
import SwiftyBeaver

struct MiniAddFriendButton: View {
    @EnvironmentObject var friends: FriendsService
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
        }
    }

    func addFriend() {
        Task {
            do {
                try await friends.addFriend(userId)
            } catch {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}

struct MiniAddFriendButton_Previews: PreviewProvider {
    static var previews: some View {
        MiniAddFriendButton(userId: "ABC")
            .environmentObject(FriendsService.make())
    }
}
