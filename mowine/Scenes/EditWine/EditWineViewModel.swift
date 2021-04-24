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
import Model

class EditWineViewModel: ObservableObject {
    @Published var isSaving = false
    @Published var isShowingSheet = false
    @Published var pickerSourceType: ImagePickerView.SourceType = .camera
    
    let form = EditWineFormModel()
    private var wineId: String?
    
    init() {
        SwiftyBeaver.debug("init")
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
    }
    
    func load(wineId: String, editWineService: EditWineService) {
        self.wineId = wineId
        
        editWineService.getWineTypes() { [weak self] result in
            switch result {
            case .success(let types): self?.form.setTypes(types)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
        
        editWineService.getWine(wineId: wineId) { [weak self] result in
            switch result {
            case .success(let wine): self?.form.setWine(wine)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
        
        editWineService.getWinePhoto(wineId: wineId) { [weak self] result in
            switch result {
            case .success(let photo): self?.form.image = photo
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    func save(editWineService: EditWineService, completion: @escaping () -> Void) {
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
        request.image = form.image
        
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

    func selectWinePhoto(from sourceType: ImagePickerView.SourceType) {
        isShowingSheet = true
        pickerSourceType = sourceType
    }
    
    func changeWinePhoto(to image: UIImage) {
        form.image = image
        isShowingSheet = false
    }
    
    func cancelSelectWinePhoto() {
        isShowingSheet = false
    }
}
