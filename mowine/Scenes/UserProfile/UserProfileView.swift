//
//  UserProfileView.swift
//  mowine
//
//  Created by Josh Freed on 2/27/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

@MainActor
struct UserProfileView: View {
    let userId: String
    
    @State private var selectedView = 1
    
    var body: some View {
        VStack(spacing: 0) {
            UserProfileHeaderView(vm: .init(userId: userId))
            
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
                TopWinesView(vm: .init(userId: userId))
            } else {
                WineCellarView(vm: .init(userId: userId))
            }
            
            Spacer()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: FriendButton(userId: userId))
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView(userId: "1")
        }
        .addPreviewEnvironment()
    }
}
