//
//  AppDelegate.swift
//  mowine
//
//  Created by Josh Freed on 1/7/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import JFLib
import PureLayout
import SwiftyBeaver
import FBSDKCoreKit
import Dip
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        JFContainer.configure()
        setupSwiftyBeaverLogging()
        setupUITestingEnvironment()
        return true
    }
    
    private func setupSwiftyBeaverLogging() {
        let console = ConsoleDestination()
        #if DEBUG
        console.minLevel = .verbose
        #else
        console.minLevel = .warning
        #endif
        SwiftyBeaver.addDestination(console)
        
//        let platform = SBPlatformDestination(appID: Secrets.SwiftyBeaver.appId,
//                                             appSecret: Secrets.SwiftyBeaver.appSecret,
//                                             encryptionKey: Secrets.SwiftyBeaver.encryptionKey)
//        
//        SwiftyBeaver.addDestination(platform)
    }
    
    private func setupUITestingEnvironment() {
        guard ProcessInfo.processInfo.arguments.contains("UI_TESTING") else {
            return
        }
        
        JFContainer.configureForUITesting()
        
        let userRepository: FakeUserRepository = try! JFContainer.shared.container.resolve()
        let session: FakeSession = try! JFContainer.shared.container.resolve()
        
        if let usersString = ProcessInfo.processInfo.environment["users"] {
            let data = usersString.data(using: .utf8)!
            let userObjects = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            let users: [User] = userObjects.map {
                var user = User(id: UserId(string: $0["id"] as! String), emailAddress: $0["emailAddress"] as! String)
                user.firstName = $0["firstName"] as? String
                return user
            }
            
            userRepository.setUsers(users)
        }
        
        if let currentUserId = ProcessInfo.processInfo.environment["currentUserId"], let user = userRepository.getById(UserId(string: currentUserId)) {
            session.setUser(user: user)
        }
    }
  
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        var handled = ApplicationDelegate.shared.application(application, open: url, options: options)
        if handled {
            return handled
        }
        
        handled = GIDSignIn.sharedInstance().handle(url)
        
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

enum MoWineError: Error {
    case error(message: String)
    case unknownError
    case notLoggedIn
    case dictionaryError(message: String)
}
