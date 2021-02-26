//
//  SwiftUIVersion.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct FriendsContainerView: View {
    @EnvironmentObject var session: ObservableSession

    @State private var activeSheet: MyAccountSheet?
    
    var body: some View {
        Group {
            if session.isAnonymous {
                AnonymousUserView() { activeSheet = $0 }
            } else {
                FriendsPage()
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .logIn: LogInView() { activeSheet = nil }
            case .signUp: SignUpView() { activeSheet = nil }
            default: EmptyView()
            }
        }
    }
}
