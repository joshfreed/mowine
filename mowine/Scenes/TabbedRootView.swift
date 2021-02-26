//
//  TabbedRootView.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Combine

final class MainTabBarData: ObservableObject {
    /// This is true when the user has selected the Item with the custom action
    @Published var isCustomItemSelected: Bool = false
    
    /// The index of the currently selected tab
    @Published var itemSelected: Int {
        didSet {
            if itemSelected == customActionItemIndex {
                previousItem = oldValue
                itemSelected = oldValue
                isCustomItemSelected = true
            }
        }
    }
    
    /// This is the index of the item that fires a custom action
    let customActionItemIndex: Int
    
    private var previousItem: Int

    init(customItemIndex: Int, initialIndex: Int = 1) {
        self.customActionItemIndex = customItemIndex
        self.itemSelected = initialIndex
        self.previousItem = initialIndex
    }
}

struct TabbedRootView: View {
    @EnvironmentObject var container: JFContainer
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
            
            FriendsContainerView()
                .tabItem {
                    Image("Friends Tab").renderingMode(.template)
                    Text("Friends")
                }
                .tag(3)
            
            MyAccountViewContainer()
                .tabItem {
                    Image("My Account Tab").renderingMode(.template)
                    Text("My Account")
                }
                .tag(4)
        }
        .accentColor(Color("Primary"))
        .sheet(isPresented: $model.isCustomItemSelected) {
            AddWineView(vm: AddWineViewModel(wineTypeRepository: try! container.resolve(), worker: try! container.resolve()))
        }
    }      
}

struct TabbedRootView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedRootView()
            .addPreviewEnvironment()
    }
}
