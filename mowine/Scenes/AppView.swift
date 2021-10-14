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
import FirebaseAnalytics

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
        .task {
            await loadApp()
        }
    }

    private func loadApp() async {
        SwiftyBeaver.debug("loadApp \(String(describing: session.userId))")

        await setupUITestingData()
        await wineTypeService.fetchWineTypes()

        Analytics.logEvent("app_appeared", parameters: [:])
        SwiftyBeaver.info("loadApp complete")
        isPreparing = false
    }

    private func setupUITestingData() async {
        guard ProcessInfo.processInfo.arguments.contains("UI_TESTING") else { return }
        let uiTestingHelper = UITestHelper()
        await uiTestingHelper.logInExistingUser()
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .addPreviewEnvironment()
    }
}
