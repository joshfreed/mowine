//
//  EditWineViewModel.swift
//  mowine
//
//  Created by Josh Freed on 1/30/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import PromiseKit
import FirebaseCrashlytics

class EditWineViewModel: ObservableObject {
    @Published var isSaving = false
    
    let editWineService: EditWineService
    let form = EditWineFormModel()
    private var onDelete: () -> Void
    private var wineId: String?
    
    init(editWineService: EditWineService, onDelete: @escaping () -> Void = { }) {
        SwiftyBeaver.debug("init")
        self.editWineService = editWineService
        self.onDelete = onDelete
        
        self.form.onDelete = { [weak self] in
            self?.deleteWine()
        }
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
    }
    
    func load(wineId: String) {
        self.wineId = wineId
        
        editWineService.getWineTypes() { result in
            switch result {
            case .success(let types): self.form.setTypes(types)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
        
        editWineService.getWine(wineId: wineId) { result in
            switch result {
            case .success(let wine): self.form.setWine(wine)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
        
        editWineService.getWinePhoto(wineId: wineId) { result in
            switch result {
            case .success(let photo): break//self.displayPhoto(photo)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    func save(completion: @escaping () -> Void) {
        guard let type = form.type else {
            return
        }
        
        isSaving = true
        
        var request = SaveWineRequest(name: form.name, rating: Double(form.rating), type: type.name)
        request.variety = form.variety?.name
        request.location = form.location
        request.price = form.price
        request.notes = form.notes
        request.pairings = form.pairings
        
        editWineService.saveWine(wineId: wineId!, request: request) { [weak self] result in
            self?.isSaving = false
            
            switch result {
            case .success: completion()
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    func deleteWine() {
        editWineService.deleteWine(wineId: wineId!) { [weak self] result in
            switch result {
            case .success: self?.onDelete()
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
