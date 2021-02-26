//
//  FriendsPage.swift
//  mowine
//
//  Created by Josh Freed on 2/17/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct FriendsPage: View {
    @StateObject var searchBar = SearchBar()
    
    var body: some View {
        NavigationView {
            Group {
                if searchBar.isActive {
                    SearchUsersView(searchBar: searchBar)
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
        FriendsPage()
            .environmentObject(FriendsService.make())
    }
}
