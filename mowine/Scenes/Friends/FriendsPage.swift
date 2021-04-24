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
    @StateObject var searchBar = SearchBar()
    @StateObject var vm = SearchUsersViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if searchBar.isActive {
                    SearchUsersView(hasSearched: vm.hasSearched, searchResults: vm.searchResults)
                        .onReceive(searchBar.$text) {
                            vm.searchTextDidChange(to: $0)
                        }
                } else {
                    MyFriendsListView()
                }
            }
            .navigationBarTitle("Friends")
            .add(searchBar)
        }
        .accentColor(.mwSecondary)
    }
}

struct FriendsPage_Previews: PreviewProvider {
    static var previews: some View {
        FriendsPage(vm: SearchUsersViewModel(users: .make()))
            .environmentObject(FriendsService.make())
    }
}
