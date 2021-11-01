//
//  UserProfileView.swift
//  mowine
//
//  Created by Josh Freed on 2/27/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct UserProfileView: View {
    let userId: String

    @StateObject private var profile = UserProfileHeaderViewModel()
    @StateObject private var topWines = TopWinesViewModel()
    @StateObject private var cellar = WineCellarViewModel()
    @State private var selectedView = 1
    
    var body: some View {
        VStack(spacing: 0) {
            UserProfileHeaderView(vm: profile)
            
            Group {
                Picker(selection: $selectedView, label: EmptyView(), content: {
                    Text("Top Wines").tag(1)
                    Text("Cellar").tag(2)
                })
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 260)
            }
            .padding(.vertical, 8)
            
            if selectedView == 1 {
                TopWinesView(vm: topWines)
            } else {
                WineCellarView(userId: userId, vm: cellar)
            }
            
            Spacer()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: FriendButton(userId: userId))
        .task { await profile.load(userId: userId) }
        .task { await topWines.load(userId: userId) }
        .task { await cellar.load(userId: userId) }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView(userId: "U1")
        }
        .addPreviewEnvironment()
        .addPreviewData()
    }
}
