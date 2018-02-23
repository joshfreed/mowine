//
//  AddWineSummaryInteractor.swift
//  mowine
//
//  Created by Josh Freed on 9/21/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AddWineSummaryBusinessLogic {
    func createWine(request: AddWineSummary.CreateWine.Request)
    func updateRating(request: AddWineSummary.UpdateRating.Request)
    func deleteWine(request: AddWineSummary.DeleteWine.Request)
}

protocol AddWineSummaryDataStore {
    var wineType: WineType! { get set }
    var variety: WineVariety? { get set }
    var photo: UIImage? { get set }
    var name: String { get set }
    var rating: Double { get set }
    var wine: Wine? { get }
}

class AddWineSummaryInteractor: AddWineSummaryBusinessLogic, AddWineSummaryDataStore {
    var presenter: AddWineSummaryPresentationLogic?
    var worker: AddWineSummaryWorker?
    var wineType: WineType!
    var variety: WineVariety?
    var photo: UIImage?
    var name: String = ""
    var rating: Double = 0
    private(set) var wine: Wine?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(wineUpdated), name: .wineUpdated, object: nil)
    }
    
    @objc func wineUpdated(notification: Notification) {
        guard let updatedWine = notification.userInfo?["wine"] as? Wine else {
            return
        }
        
        wine = updatedWine
        
        let response = AddWineSummary.CreateWine.Response(wine: wine)
        presenter?.presentWine(response: response)
    }
    
    // MARK: Create wine

    func createWine(request: AddWineSummary.CreateWine.Request) {
        
        worker?.createWine(type: wineType, variety: variety, photo: photo, name: name, rating: rating) { result in
            switch result {
            case .success(let wine):
                self.wine = wine
                let response = AddWineSummary.CreateWine.Response(wine: wine)
                self.presenter?.presentWine(response: response)
            case .failure(let error):
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: Update rating
    
    func updateRating(request: AddWineSummary.UpdateRating.Request) {
        rating = request.rating

        if let wine = wine {
            worker?.updateRating(of: wine, to: request.rating)
        }

        let response = AddWineSummary.UpdateRating.Response()
        presenter?.presentRating(response: response)
    }
    
    // MARK: Delete wine
    
    func deleteWine(request: AddWineSummary.DeleteWine.Request) {
        guard let wine = wine else {
            return
        }
        
        worker?.delete(wine: wine)
        
        let response = AddWineSummary.DeleteWine.Response()
        presenter?.presentWineDeleted(response: response)
    }
}