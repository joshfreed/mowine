//
//  FriendsPage.swift
//  mowine
//
//  Created by Josh Freed on 2/17/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct FriendsPage: View {
    @EnvironmentObject private var session: ObservableSession
    @StateObject private var vm = SearchUsersViewModel()

    var body: some View {
        if session.isAnonymous {
            AnonymousUserView()
        } else {
            NavigationView {
                SearchableFriendsPage(hasSearched: vm.hasSearched, searchResults: vm.searchResults)
                    .navigationBarTitle("Friends")
                    .toolbarTitleDisplayMode(.inline)
                    .searchable(text: $vm.searchText)
            }
            .accentColor(.mwSecondary)
            .analyticsScreen(name: "My Friends", class: "FriendsPage")
        }
    }
}

struct SearchableFriendsPage: View {
    @Environment(\.isSearching) var isSearching

    let hasSearched: Bool
    let searchResults: [SearchUsersResponse.User]

    var body: some View {
        if isSearching {
            SearchUsersView(hasSearched: hasSearched, searchResults: searchResults)
        } else {
            MyFriendsListView()
        }
    }
}

struct FriendsPage_Previews: PreviewProvider {
    static var previews: some View {
        FriendsPage()
            .addPreviewEnvironment()
    }
}
