//
//  MoWineApp.swift
//  mowine
//
//  Created by Josh Freed on 4/4/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import Model

@main
struct WoWineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var session = ObservableSession(session: try! JFContainer.shared.container.resolve())
    @StateObject var wineTypeService = WineTypeService(wineTypeRepository: try! JFContainer.shared.container.resolve())

    init() {
        JFContainer.configure()
        setupSwiftyBeaverLogging()
        setupUITestingEnvironment()
        configureUIKit()
        configureStuff()

        SwiftyBeaver.info("MoWineApp::init")
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .task { await setupUITestingData() }
                .addAppEnvironment()
                .environmentObject(session)
                .environmentObject(wineTypeService)
        }
    }

    private func setupSwiftyBeaverLogging() {
        let console = ConsoleDestination()
        #if DEBUG
        console.minLevel = .verbose
        #else
        console.minLevel = .warning
        #endif
        SwiftyBeaver.addDestination(console)
    }

    private func setupUITestingEnvironment() {
        guard ProcessInfo.processInfo.arguments.contains("UI_TESTING") else { return }
        JFContainer.configureForUITesting()
    }

    private func configureStuff() {
        JFContainer.shared.configurators.forEach {
            $0.configure()
        }
    }

    private func configureUIKit() {
        let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    private func setupUITestingData() async {
        guard ProcessInfo.processInfo.arguments.contains("UI_TESTING") else { return }
        let uiTestingHelper = UITestHelper()
        await uiTestingHelper.logInExistingUser()
    }
}

extension View {
    func addAppEnvironment() -> some View {
        let container = JFContainer.shared.container

        return self
            .environmentObject(try! JFContainer.shared.container.resolve() as FriendsService)
            .environmentObject(try! JFContainer.shared.container.resolve() as GetUserWinesByTypeQuery)
            .environmentObject(try! container.resolve() as MyWinesService)
    }
}
