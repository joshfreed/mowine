//
//  AppView.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct AppView: View {
    let isPreparing: Bool
    
    var body: some View {
        if isPreparing {
            SplashScreen()
        } else {
            TabbedRootView()
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(isPreparing: false)
            .addPreviewEnvironment()
    }
}
