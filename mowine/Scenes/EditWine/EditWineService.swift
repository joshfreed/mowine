//
//  EditWineService.swift
//  mowine
//
//  Created by Josh Freed on 1/31/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import PromiseKit
import FirebaseCrashlytics

protocol EditWineService {
    func getWine(wineId: String) -> Promise<WineViewModel>
    func getWineTypes() -> Promise<[WineTypeViewModel]>
    func getWine(wineId: String, completion: @escaping (Swift.Result<Wine, Error>) -> Void)
    func getWineTypes(completion: @escaping (Swift.Result<[WineType], Error>) -> Void)
    func getWinePhoto(wineId: String, completion: @escaping (Swift.Result<UIImage?, Error>) -> ())
    func saveWine(wineId: String, request: SaveWineRequest, completion: @escaping (Swift.Result<Void, Error>) -> ())
    func deleteWine(wineId: String, completion: @escaping (Swift.Result<Void, Error>) -> ())
}

class EditWineServiceImpl: EditWineService {
    let wineRepository: WineRepository
    let wineTypeRepository: WineTypeRepository
    let imageWorker: WineImageWorkerProtocol
    
    private var wineTypes: [WineType] = []
    
    init(wineRepository: WineRepository, wineTypeRepository: WineTypeRepository, imageWorker: WineImageWorkerProtocol) {
        self.wineRepository = wineRepository
        self.wineTypeRepository = wineTypeRepository
        self.imageWorker = imageWorker
    }

    func getWine(wineId: String) -> Promise<WineViewModel> {
        return Promise<WineViewModel> { seal in
            wineRepository.getWine(by: WineId(string: wineId)) { result in
                switch result {
                case .success(let wine): seal.fulfill(WineViewModel.from(model: wine))
                case .failure(let error): seal.reject(error)
                }
            }
        }
    }
    
    func getWineTypes() -> Promise<[WineTypeViewModel]> {
        return Promise<[WineTypeViewModel]> { seal in
            wineTypeRepository.getAll { result in
                switch result {
                case .success(let wineTypes):
                    self.wineTypes = wineTypes
                    let mapped = wineTypes.map({ WineTypeViewModel.from(model: $0) })
                    seal.fulfill(mapped)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    func getWine(wineId: String, completion: @escaping (Swift.Result<Wine, Error>) -> Void) {
        wineRepository.getWine(by: WineId(string: wineId), completion: completion)
    }
    
    func getWineTypes(completion: @escaping (Swift.Result<[WineType], Error>) -> Void) {
        wineTypeRepository.getAll { result in
            switch result {
            case .success(let wineTypes):
                self.wineTypes = wineTypes
                completion(.success(wineTypes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWinePhoto(wineId: String, completion: @escaping (Swift.Result<UIImage?, Error>) -> ()) {
        imageWorker.fetchPhoto(wineId: WineId(string: wineId)) { result in
            switch result {
            case .success(let data):
                var photo: UIImage? = nil
                if let data = data {
                    photo = UIImage(data: data)
                }
                completion(.success(photo))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func saveWine(wineId: String, request: SaveWineRequest, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        let wineId = WineId(string: wineId)
        
        if let thumbnail = imageWorker.createImages(wineId: wineId, photo: request.image) {
            NotificationCenter.default.post(name: .wineUpdated, object: nil, userInfo: ["wineId": wineId.asString, "thumbnail": thumbnail])
        }
        
        wineRepository.getWine(by: wineId) { result in
            switch result {
            case .success(let wine): self.updateWine(wine: wine, from: request, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func updateWine(wine: Wine, from request: SaveWineRequest, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        wine.name = request.name
        wine.rating = request.rating
        wine.location = request.location
        wine.notes = request.notes
        wine.price = request.price
        wine.pairings = request.pairings
        
        guard let newType = wineTypes.first(where: { $0.name == request.type }) else {
            completion(.failure(EditWineServiceError.invalidWineType))
            return
        }
        
        wine.type = newType
        
        if let varietyName = request.variety, let variety = wine.type.getVariety(named: varietyName) {
            wine.variety = variety
        } else {
            wine.variety = nil
        }
        
        wineRepository.save(wine) { result in
            switch result {
            case .success: completion(.success(()))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func deleteWine(wineId: String, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        let wineId = WineId(string: wineId)
        wineRepository.getWine(by: wineId) { result in
            switch result {
            case .success(let wine): self.deleteWine(wine, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func deleteWine(_ wine: Wine, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        wineRepository.delete(wine) { result in
            switch result {
            case .success: completion(.success(()))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

enum EditWineServiceError: Error {
    case invalidWineType
}

struct SaveWineRequest {
    let name: String
    let rating: Double
    let type: String
    var variety: String?
    var location: String?
    var price: String?
    var notes: String?
    var image: UIImage?
    var pairings: [String] = []
    
    init(name: String, rating: Double, type: String) {
        self.name = name
        self.rating = rating
        self.type = type
    }
}
