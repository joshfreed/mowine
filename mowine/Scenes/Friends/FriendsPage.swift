//
//  FriendsPage.swift
//  mowine
//
//  Created by Josh Freed on 2/17/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct FriendsPage: View {
    @StateObject var vm = SearchUsersViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            InnerFriendsPage(vm: vm, searchText: $searchText)
                .navigationBarTitle("Friends")
                .searchable(text: $searchText)
                .onChange(of: searchText) {
                    vm.searchTextDidChange(to: $0)
                }
        }
        .accentColor(.mwSecondary)
    }
}

struct InnerFriendsPage: View {
    @Environment(\.isSearching) var isSearching
    @ObservedObject var vm: SearchUsersViewModel
    @Binding var searchText: String

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
        FriendsPage(vm: SearchUsersViewModel(users: .make()))
            .environmentObject(FriendsService.make())
    }
}
