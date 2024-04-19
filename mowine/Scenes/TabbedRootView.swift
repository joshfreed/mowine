//
//  TabbedRootView.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Combine
import MoWine_Application

struct TabbedRootView: View {
    @StateObject var model = MainTabBarData(customItemIndex: 2)
    
    var body: some View {
        TabView(selection: $model.itemSelected) {
            MyCellarView()
                .tabItem {
                    Image("My Wines Tab").renderingMode(.template)
                    Text("My Cellar")
                }
                .tag(1)
            
            Text("Nothing")
                .tabItem {
                    Image("Add Wine Tab").renderingMode(.template)
                    Text("Add Wine")
                }
                .tag(2)
            
            FriendsPage()
                .tabItem {
                    Image("Friends Tab").renderingMode(.template)
                    Text("Friends")
                }
                .tag(3)
            
            MyAccountPage()
                .tabItem {
                    Image("My Account Tab").renderingMode(.template)
                    Text("My Account")
                }
                .tag(4)
        }
        .accentColor(Color(.mwPrimary))
        .sheet(isPresented: $model.isCustomItemSelected) {
            AddWineView()
        }
    }      
}

struct TabbedRootView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedRootView()
            .addPreviewEnvironment()
    }
}
