//
//  SceneDelegate.swift
//  mowine
//
//  Created by Josh Freed on 10/4/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit
import SwiftUI
import GoogleSignIn
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        JFContainer.shared.configurators.forEach {
            $0.configure()
        }
        
        let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        let appView = AppView()
            .addAppEnvironment()
       
        let rootVC = UIHostingController(rootView: appView)

        GIDSignIn.sharedInstance().presentingViewController = rootVC
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
}

extension View {
    func addAppEnvironment() -> some View {
        let session = ObservableSession(session: JFContainer.shared.session)                
        let emailLogInViewModel = EmailLogInViewModel(emailAuth: try! JFContainer.shared.container.resolve())        
        let signUpWorker = SignUpWorker(
            emailAuthService: try! JFContainer.shared.container.resolve(),
            userRepository: try! JFContainer.shared.container.resolve(),
            session: try! JFContainer.shared.container.resolve()
        )
        let emailSignUpViewModel = EmailSignUpViewModel(worker: signUpWorker)
        let socialAuthViewModel = SocialAuthViewModel(firstTimeWorker: JFContainer.shared.firstTimeWorker())
        
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
