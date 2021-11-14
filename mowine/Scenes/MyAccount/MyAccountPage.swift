//
//  MyAccountPage.swift
//  mowine
//
//  Created by Josh Freed on 11/13/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyAccountPage: View {
    @EnvironmentObject var session: ObservableSession

    var body: some View {
        if session.isAnonymous {
            AnonymousUserView()
        } else {
            MyAccountView()
        }
    }
}
