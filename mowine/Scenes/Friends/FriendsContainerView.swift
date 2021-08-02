//
//  SwiftUIVersion.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct FriendsContainerView: View {
    @EnvironmentObject var session: ObservableSession

    var body: some View {
        if session.isAnonymous {
            AnonymousUserView()
        } else {
            FriendsPage()
        }
    }
}
