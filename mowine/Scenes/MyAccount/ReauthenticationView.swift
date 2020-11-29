//
//  ReauthenticationView.swift
//  mowine
//
//  Created by Josh Freed on 11/29/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct ReauthenticationView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 28) {
                Text("Please reauthenticate in order to continue.")
                LoginProviderView()
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                
            })
        }
        .accentColor(.mwSecondary)
    }
}

struct ReauthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        ReauthenticationView()
    }
}
