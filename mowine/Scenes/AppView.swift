//
//  AppView.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct AppView: View {
    @EnvironmentObject var session: ObservableSession
    @State private var isPreparing: Bool = true
    
    var body: some View {
        Group {
            if isPreparing {
                SplashScreen()
            } else {
                TabbedRootView()
            }
        }        
        .onAppear {
            startSession()
        }
    }
    
    private func startSession() {
        session.start { result in
            isPreparing = false
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .addPreviewEnvironment()
    }
}
