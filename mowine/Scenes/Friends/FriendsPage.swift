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
    @EnvironmentObject var session: ObservableSession
    @StateObject var vm = SearchUsersViewModel()
    @State private var searchText: String = ""

    var body: some View {
        if session.isAnonymous {
            AnonymousUserView()
        } else {
            NavigationView {
                SearchableFriendsPage(vm: vm)
                    .navigationBarTitle("Friends")
                    .searchable(text: $searchText)
                    .onChange(of: searchText) {
                        vm.searchUsers(matching: $0)
                    }
            }
            .accentColor(.mwSecondary)
            .analyticsScreen(name: "My Friends", class: "FriendsPage")
        }
    }
}

struct SearchableFriendsPage: View {
    @Environment(\.isSearching) var isSearching
    @ObservedObject var vm: SearchUsersViewModel

    var body: some View {
        if isSearching {
            SearchUsersView(hasSearched: vm.hasSearched, searchResults: vm.searchResults)
        } else {
            MyFriendsListView()
        }
    }
}

struct FriendsPage_Previews: PreviewProvider {
    static var previews: some View {
        FriendsPage(vm: SearchUsersViewModel())
            .environmentObject(FriendsService.make())
            .addPreviewEnvironment()
    }
}
