//
//  MyWinesInteractor.swift
//  mowine
//
//  Created by Josh Freed on 3/15/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import JFLib
import AWSAppSync
import SwiftyBeaver

protocol MyWinesBusinessLogic {
    func fetchMyWines(request: MyWines.FetchMyWines.Request)
    func selectWine(atIndex index: Int)
}

protocol MyWinesDataStore {
    var selectedWine: Wine? { get set }
}

class MyWinesInteractor: MyWinesBusinessLogic, MyWinesDataStore {
    var presenter: MyWinesPresentationLogic?
    var worker: MyWinesWorker?
    let appSyncClient: AWSAppSyncClient
    private var discard: Cancellable?
    
    var selectedWine: Wine?
    private var wines: [Wine] = []
    
    init() {
        self.appSyncClient = AWSContainer.shared.appSyncClient
        
        registerNotifications()
        registerSubscriptions()
    }
    
    func registerNotifications() {
        // Or, maybe instead of these notifications, load the wines from the cache every time the view appears
        
        NotificationCenter.default.addObserver(self, selector: #selector(wineUpdated), name: .wineUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(wineAdded), name: .wineAdded, object: nil)
    }
    
    func registerSubscriptions() {
        discard = try! self.appSyncClient.subscribe(subscription: OnCreateWineSubscription()) { result, transaction, error in
            SwiftyBeaver.debug("onCreateWine")
            
            if let error = error {
                SwiftyBeaver.error("\(error)")
                SwiftyBeaver.error(error.localizedDescription)
                return
            }
            
            if let errors = result?.errors {
                SwiftyBeaver.error("Result had \(errors.count) errors")
                SwiftyBeaver.error("\(errors)")
                return
            }
            
            guard let result = result else {
                return
            }
            
            SwiftyBeaver.info("onCreateWine: \(result.data!.onCreateWine!.name)")
            let newWine = result.data!.onCreateWine!.toWine()
            self.insertWine(newWine)
        }
    }
    
    @objc func wineUpdated(notification: Notification) {
        guard let updatedWine = notification.userInfo?["wine"] as? Wine else {
            return
        }
        
        presenter?.presentUpdatedWine(wine: updatedWine)
        
        if let thumbnail = notification.userInfo?["thumbnail"] as? Data {
            let response = MyWines.FetchThumbnail.Response(wine: updatedWine, thumbnail: thumbnail)
            presenter?.presentThumbnail(response: response)
        }
    }
    
    @objc func wineAdded(notification: Notification) {
        guard let newWine = notification.userInfo?["wine"] as? Wine else {
            return
        }
        
        insertWine(newWine)
    }
    
    func insertWine(_ wine: Wine) {
        if wines.contains(wine) {
            return
        }
        
        wines.insert(wine, at: 0)        
        presenter?.presentWineAdded(wine: wine)
    }
    
    // MARK: Business logic
    
    func fetchMyWines(request: MyWines.FetchMyWines.Request) {
        SwiftyBeaver.debug("fetchMyWines")
        
        worker?.fetchMyWines() { result in
            switch result {
            case .success(let wines):
                self.wines = wines
                self.presentWines()
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
            }
        }
    }
    
    private func presentWines() {
        let response = MyWines.FetchMyWines.Response(wines: wines)
        presenter?.presentMyWines(response: response)
    }
    
    // MARK: Select wine
    
    func selectWine(atIndex index: Int) {
        selectedWine = wines[index]
    }
}
