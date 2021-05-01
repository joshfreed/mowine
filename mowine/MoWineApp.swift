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

    init() {
        JFContainer.configure()
        setupSwiftyBeaverLogging()
        setupUITestingEnvironment()
        configureStuff()
        configureNavBar()
    }

    var body: some Scene {
        WindowGroup {
            AppView()
                .addAppEnvironment()
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
        guard ProcessInfo.processInfo.arguments.contains("UI_TESTING") else {
            return
        }

        JFContainer.configureForUITesting()
    }

    private func configureStuff() {
        JFContainer.shared.configurators.forEach {
            $0.configure()
        }
    }

    private func configureNavBar() {
        let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension View {
    func addAppEnvironment() -> some View {
        let container = JFContainer.shared.container

        let session = ObservableSession(session: JFContainer.shared.session)
        let emailLogInViewModel = EmailLogInViewModel(emailAuth: try! JFContainer.shared.container.resolve())
        let signUpWorker = SignUpWorker(
            emailAuthService: try! JFContainer.shared.container.resolve(),
            userRepository: try! JFContainer.shared.container.resolve(),
            session: try! JFContainer.shared.container.resolve()
        )
        let emailSignUpViewModel = EmailSignUpViewModel(worker: signUpWorker)
        let socialAuthViewModel = SocialAuthViewModel(
            firstTimeWorker: JFContainer.shared.firstTimeWorker(),
            socialSignInMethods: JFContainer.shared.socialSignInMethods()
        )

        let wineWorker = WineWorker(
            wineRepository: try! container.resolve(),
            imageWorker: try! container.resolve(),
            session: try! container.resolve()
        )

        return self
            .environmentObject(JFContainer.shared)
            .environmentObject(makeMyCellarViewModel())
            .environmentObject(makeMyAccountViewModel())
            .environmentObject(session)
            .environmentObject(emailLogInViewModel)
            .environmentObject(emailSignUpViewModel)
            .environmentObject(socialAuthViewModel)
            .environmentObject(try! JFContainer.shared.container.resolve() as FriendsService)
            .environmentObject(try! JFContainer.shared.container.resolve() as UsersService)
            .environmentObject(try! JFContainer.shared.container.resolve() as GetUserWinesByTypeQuery)
            .environmentObject(try! JFContainer.shared.container.resolve() as GetWineDetailsQuery)
            .environmentObject(WineTypeService(wineTypeRepository: try! container.resolve()))
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

fileprivate func makeMyAccountViewModel() -> MyAccountViewModel {
    let session: Session = try! JFContainer.shared.container.resolve()
    let getMyAccountQuery = GetMyAccountQueryHandler(userRepository: JFContainer.shared.userRepository, session: session)
    let profilePictureWorker: ProfilePictureWorkerProtocol = try! JFContainer.shared.container.resolve()
    let signOutCommand = SignOutCommand(session: session)
    return MyAccountViewModel(
        getMyAccountQuery: getMyAccountQuery,
        profilePictureWorker: profilePictureWorker,
        signOutCommand: signOutCommand
    )
}
