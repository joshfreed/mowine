//
//  AppDelegate.swift
//  mowine
//
//  Created by Josh Freed on 1/7/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import CoreData
import JFLib
import PureLayout
import AWSMobileClient
import AWSAuthCore
import AWSUserPoolsSignIn
import AWSFacebookSignIn
import SwiftyBeaver

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor.mwButtonSecondary

        setupSwiftyBeaverLogging()
        
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
        AWSDDLog.sharedInstance.logLevel = .info
        
        AWSMobileClient.sharedInstance().addUserStateListener(self) { userState, info in
            switch (userState) {
            case .guest:
                SwiftyBeaver.debug("user is in guest mode.")
            case .signedOut:
                SwiftyBeaver.debug("user signed out")
            case .signedIn:
                SwiftyBeaver.debug("user is signed in.")
            case .signedOutUserPoolsTokenInvalid:
                SwiftyBeaver.debug("need to login again.")
            case .signedOutFederatedTokensInvalid:
                SwiftyBeaver.debug("user logged in via federation, but currently needs new tokens")
            default:
                SwiftyBeaver.debug("unsupported")
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()!
        window = UIWindow()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        Container.shared.syncManager.initialize()
        
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
    
/*
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return AWSMobileClient.sharedInstance().interceptApplication(
            application, open: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        )
    }
 */

    private func deleteDatabase() {
        var url = NSPersistentContainer.defaultDirectoryURL()
        url.appendPathComponent("mowine.sqlite")
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            fatalError("\(error)")
        }        
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
        SwiftyBeaver.info("AppDelegate::applicationDidBecomeActive")      
        
        if Container.shared.session.isLoggedIn {
            Container.shared.syncManager.sync()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = Container.shared.persistentContainer

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

enum MoWineError: Error {
    case unknownError
    case notLoggedIn
}
