//
//  AppView.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model
import SwiftyBeaver

@MainActor
struct AppView: View {
    @EnvironmentObject var session: ObservableSession
    @EnvironmentObject var wineTypeService: WineTypeService
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
            Task {
                await loadUserData()
            }
        }
    }

    private func loadUserData() async {
        SwiftyBeaver.debug("loadUserData \(String(describing: session.userId))")
        await wineTypeService.fetchWineTypes()
        isPreparing = false
        SwiftyBeaver.info("loadUserData complete")
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .addPreviewEnvironment()
    }
}
