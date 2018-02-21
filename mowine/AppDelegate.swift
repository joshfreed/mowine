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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor.mwButtonSecondary
        
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            preLoadData()
            defaults.set(true, forKey: "isPreloaded")
        }
        
        return true
    }

    private func deleteDatabase() {
        var url = NSPersistentContainer.defaultDirectoryURL()
        url.appendPathComponent("mowine.sqlite")
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            fatalError("\(error)")
        }
    }
    
    private func preLoadData() {
        let context = persistentContainer.viewContext
        
        deleteAllEntity("Variety")
        deleteAllEntity("Type")
        
        let redWine = ManagedWineType(context: context)
        redWine.name = "Red"
        redWine.addToVarieties(makeVariety(name: "Cabernet Sauvignon"))
        redWine.addToVarieties(makeVariety(name: "Chianti"))
        redWine.addToVarieties(makeVariety(name: "Malbec"))
        redWine.addToVarieties(makeVariety(name: "Merlot"))
        redWine.addToVarieties(makeVariety(name: "Pinot Nior"))
        redWine.addToVarieties(makeVariety(name: "Red Blend"))
        
        let whiteWine = ManagedWineType(context: context)
        whiteWine.name = "White"
        whiteWine.addToVarieties(makeVariety(name: "Chardonnay"))
        whiteWine.addToVarieties(makeVariety(name: "Gewürztraminer"))
        whiteWine.addToVarieties(makeVariety(name: "Pinot Blanc"))
        whiteWine.addToVarieties(makeVariety(name: "Pinot Grigio"))
        whiteWine.addToVarieties(makeVariety(name: "Riesling"))
        whiteWine.addToVarieties(makeVariety(name: "Sauvignon Blanc"))
        whiteWine.addToVarieties(makeVariety(name: "Moscato"))
        whiteWine.addToVarieties(makeVariety(name: "White Blend"))
        
        let bubbly = ManagedWineType(context: context)
        bubbly.name = "Bubbly"
        bubbly.addToVarieties(makeVariety(name: "Champagne"))
        bubbly.addToVarieties(makeVariety(name: "Prosecco"))

        let rose = ManagedWineType(context: context)
        rose.name = "Rosé"
        
        let other = ManagedWineType(context: context)
        other.name = "Other"
        
        saveContext()
    }
    
    private func makeVariety(name: String) -> ManagedWineVariety {
        let variety = ManagedWineVariety(context: persistentContainer.viewContext)
        variety.name = name
        return variety
    }

    private func deleteAllEntity(_ entityName: String) {
        let context = persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
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

