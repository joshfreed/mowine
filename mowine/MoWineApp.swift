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
}

extension View {
    func addAppEnvironment() -> some View {
        let container = JFContainer.shared.container

        let wineWorker = WineWorker(
            wineRepository: try! container.resolve(),
            imageWorker: try! container.resolve(),
            session: try! container.resolve()
        )

        return self
            .environmentObject(JFContainer.shared)
            .environmentObject(makeMyCellarViewModel())
            .environmentObject(try! JFContainer.shared.container.resolve() as FriendsService)
            .environmentObject(try! JFContainer.shared.container.resolve() as UsersService)
            .environmentObject(try! JFContainer.shared.container.resolve() as GetUserWinesByTypeQuery)
            .environmentObject(try! JFContainer.shared.container.resolve() as GetWineDetailsQuery)
            .environmentObject(wineWorker)
            .environmentObject(try! container.resolve() as EditWineService)
            .environmentObject(try! container.resolve() as MyWinesService)
    }
}

fileprivate func makeMyCellarViewModel() -> MyCellarViewModel {
    let searchMyCellarQuery = SearchMyCellarQuery(
        wineRepository: JFContainer.shared.wineRepository,
        session: JFContainer.shared.session
    )
    let getWinesByTypeQuery = GetWinesByTypeQuery(
        wineRepository: JFContainer.shared.wineRepository,
        session: JFContainer.shared.session
    )
    return MyCellarViewModel(
        wineTypeRepository: JFContainer.shared.wineTypeRepository,
        thumbnailFetcher: try! JFContainer.shared.container.resolve(),
        searchMyCellarQuery: searchMyCellarQuery,
        getWinesByTypeQuery: getWinesByTypeQuery
    )
}
