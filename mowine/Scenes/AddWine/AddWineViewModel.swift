//
//  AddWineViewModel.swift
//  mowine
//
//  Created by Josh Freed on 2/16/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver

class AddWineViewModel: ObservableObject {
    @Published private(set) var wineTypes: [WineType] = []
    @Published private(set) var closeModal = false
    
    private let wineTypeRepository: WineTypeRepository
    private let worker: WineWorker
    
    init(wineTypeRepository: WineTypeRepository, worker: WineWorker) {
        self.wineTypeRepository = wineTypeRepository
        self.worker = worker
    }
    
    func load() {
        wineTypeRepository.getAll { result in
            switch result {
            case .success(let types): self.wineTypes = types
            case .failure(let error): SwiftyBeaver.error("\(error)")
            }
        }
    }
    
    func createWine(model: NewWineModel, onError: @escaping (Error) -> Void) {
        var photoImage: UIImage?
        
        if let data = model.image {
            photoImage = UIImage(data: data)
        }
        
        worker.createWine(
            type: model.wineType!,
            variety: model.wineVariety,
            name: model.name,
            rating: Double(model.rating),
            photo: photoImage
        ) { result in
            switch result {
            case .success: self.closeModal = true
            case .failure(let error): onError(error)
            }
        }
    }
}
