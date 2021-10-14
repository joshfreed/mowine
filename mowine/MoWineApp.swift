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

    @StateObject var session = ObservableSession(session: try! JFContainer.shared.resolve())
    @StateObject var wineTypeService = WineTypeService(wineTypeRepository: try! JFContainer.shared.resolve())

    init() {
        setupSwiftyBeaverLogging()
        configureUIKit()
        setupDependencyInjection()
        SwiftyBeaver.info("MoWineApp::init")
    }

    var body: some Scene {
        WindowGroup {
            AppView()
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

    private func configureUIKit() {
        let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    private func setupDependencyInjection() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            JFContainer.configureForPreviews()
        } else {
            let useEmulator = ProcessInfo.processInfo.arguments.contains("UI_TESTING")
            FirebaseConfigurator().configure(useEmulator: useEmulator)
            JFContainer.configure()
        }
    }
}

extension View {
    func addAppEnvironment() -> some View {
        self
            .environmentObject(try! JFContainer.shared.resolve() as FriendsService)
            .environmentObject(try! JFContainer.shared.resolve() as GetUserWinesByTypeQuery)
            .environmentObject(try! JFContainer.shared.resolve() as MyWinesService)
    }
}
