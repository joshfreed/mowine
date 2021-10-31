//
//  SearchUsersView.swift
//  mowine
//
//  Created by Josh Freed on 2/17/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct SearchUsersView: View {
    let hasSearched: Bool
    let searchResults: [UsersService.UserSearchResult]

    var body: some View {
        if hasSearched {
            if searchResults.isEmpty {
                SearchUsersMessage(message: "No users match your search.")
            } else {
                List(searchResults) { result in
                    NavigationLink(destination: UserProfileView(userId: result.id)) {
                        UserSearchResultView(user: result)
                            .accessibilityElement(children: .contain)
                            .accessibilityIdentifier("SearchResult - \(result.fullName)")
                    }
                }
                .listStyle(.plain)
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("SearchResults")
            }
        } else {
            SearchUsersMessage(message: "Try searching for people you know")
        }
    }
}

struct SearchUsersMessage: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .font(.system(size: 21))
                .foregroundColor(Color("Text Label"))
            Spacer()
        }.padding(.top, 24)
    }
}

struct SearchFriendsView_Previews: PreviewProvider {
    static var searchResults: [UsersService.UserSearchResult] = [
        .init(id: "", email: "", fullName: "Franky Twofingers", profilePictureUrl: nil)
    ]

    static var previews: some View {
        NavigationView {
            SearchUsersView(hasSearched: true, searchResults: searchResults)
        }
        .environmentObject(MyFriends.fake())
    }
}
