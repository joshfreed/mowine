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

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupSwiftyBeaverLogging()
        
        window = UIWindow()
        window?.rootViewController = StartViewController()
        window?.makeKeyAndVisible()
        
//        Container.shared.syncManager.initialize()

        return true
    }
    
    private func setupSwiftyBeaverLogging() {
        let console = ConsoleDestination()
        console.minLevel = .verbose
        SwiftyBeaver.addDestination(console)
        
        let platform = SBPlatformDestination(appID: Secrets.SwiftyBeaver.appId,
                                             appSecret: Secrets.SwiftyBeaver.appSecret,
                                             encryptionKey: Secrets.SwiftyBeaver.encryptionKey)
        
        SwiftyBeaver.addDestination(platform)
    }
  
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        var handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
        if handled {
            return handled
        }
        handled = GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: [:])
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}

enum MoWineError: Error {
    case error(message: String)
    case unknownError
    case notLoggedIn
    case dictionaryError(message: String)
}
