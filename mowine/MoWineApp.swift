//
//  MoWineApp.swift
//  mowine
//
//  Created by Josh Freed on 4/4/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import MoWine_Application
import MoWine_Infrastructure
import Dip
@_exported import JFLib_DI
import JFLib_Mediator
import Combine

var sessionCancellables = Set<AnyCancellable>()

@main
struct WoWineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var session = ObservableSession()
    @StateObject private var myCellar = MyCellar()
    @StateObject private var myFriends = MyFriends()

    init() {
        setupSwiftyBeaverLogging()
        configureUIKit()
        setupDependencyInjection()
        SwiftyBeaver.info("MoWineApp::init")
    }

    var body: some Scene {
        WindowGroup {
            TabbedRootView()
                .addAppEnvironment()
                .environmentObject(session)
                .environmentObject(myCellar)
                .environmentObject(myFriends)
                .task {
                    SwiftyBeaver.verbose("Task on appear fired")
                    await setupUITestingData()
                }
                .onChange(of: session.userId) { newValue in
                    SwiftyBeaver.verbose("Session userId changed: \(String(describing: newValue))")

                    sessionCancellables.forEach { $0.cancel() }
                    sessionCancellables.removeAll()

                    let getMyWines: GetMyWinesHandler = try! JFServices.resolve()
                    getMyWines
                        .subscribe()
                        .replaceError(with: GetMyWinesResponse(wines: []))
                        .receive(on: RunLoop.main)
                        .sink { response in myCellar.present(response) }
                        .store(in: &sessionCancellables)

                    let getMyFriends: GetMyFriendsQueryHandler = try! JFServices.resolve()
                    getMyFriends
                        .subscribe()
                        .replaceError(with: GetMyFriendsQueryResponse(friends: []))
                        .receive(on: RunLoop.main)
                        .sink { response in myFriends.present(response) }
                        .store(in: &sessionCancellables)
                }
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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mwButtonPrimary
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .darkGray
    }

    private func setupDependencyInjection() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            JFServices.configureForPreviews()
        } else {
            let useEmulator = ProcessInfo.processInfo.arguments.contains("UI_TESTING")
            FirebaseConfigurator().configure(useEmulator: useEmulator)
            JFServices.configure()
        }

        let mediator: Mediator = try! JFServices.resolve()
        MoWine_Application.DependencyInjection.registerCommands(mediator: mediator)
        MoWine_Application.DependencyInjection.registerQueries(mediator: mediator)
    }

    private func setupUITestingData() async {
        guard ProcessInfo.processInfo.arguments.contains("UI_TESTING") else { return }
        let uiTestingHelper = UITestHelper()
        await uiTestingHelper.logInExistingUser()
    }
}

extension View {
    func addAppEnvironment() -> some View {
        self
            .environmentObject(try! JFServices.resolve() as GetUserWinesByTypeQuery)
    }
}

extension JFServices {
    static func configure() {
        let container = DependencyContainer { container in
            MoWine_Application.DependencyInjection.registerServices(container: container)
            MoWine_Infrastructure.DependencyInjection.registerServices(container: container)
            MoWine_Infrastructure.DependencyInjection.registerFirebaseServices(container: container)
        }

        let resolver = DipServiceResolver(container: container)

        JFServices.initialize(resolver: resolver)
    }

    static func configureForPreviews() {
        let container = DependencyContainer { container in
            PreviewServices.registerServices(container: container)
            MoWine_Application.DependencyInjection.registerServices(container: container)
            MoWine_Infrastructure.DependencyInjection.registerServices(container: container)
        }

        let resolver = DipServiceResolver(container: container)

        JFServices.initialize(resolver: resolver)
    }
}
