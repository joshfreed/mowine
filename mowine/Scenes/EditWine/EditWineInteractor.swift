//
//  EditWineInteractor.swift
//  mowine
//
//  Created by Josh Freed on 2/18/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol EditWineInteractorInput {
    var wine: Wine! { get set }
    func fetchWine(request: EditWine.FetchWine.Request)
    func saveWine(request: EditWine.SaveWine.Request)
}

protocol EditWineInteractorOutput {
    func presentWine(response: EditWine.FetchWine.Response)
    func navigateToMyWines()
    func presentError(_ error: Error)
}

class EditWineInteractor: EditWineInteractorInput {
    var output: EditWineInteractorOutput!
    let worker: EditWineWorker
    let wineTypeWorker: WineTypeWorker
    var wine: Wine!

    init(worker: EditWineWorker, wineTypeWorker: WineTypeWorker) {
        self.worker = worker
        self.wineTypeWorker = wineTypeWorker
    }
    
    // MARK: - Business logic

    func fetchWine(request: EditWine.FetchWine.Request) {
        let wineTypes = wineTypeWorker.getWineTypes()
        let response = EditWine.FetchWine.Response(wine: wine, wineTypes: wineTypes)
        output.presentWine(response: response)
    }
    
    func saveWine(request: EditWine.SaveWine.Request) {        
        do {
            try worker.saveWine(wine: wine, request: request)
            NotificationCenter.default.post(name: .wineUpdated, object: nil, userInfo: ["wine": wine])
            output.navigateToMyWines()
        } catch {
            output.presentError(error)
        }
    }
}
