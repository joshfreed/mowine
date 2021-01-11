//
//  EditWineViewController.swift
//  mowine
//
//  Created by Josh Freed on 2/18/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Eureka
import SwiftyBeaver
import PromiseKit
import FirebaseCrashlytics

class EditWineViewController: FormViewController {
    var editWineService: EditWineService!
    let wineForm = WineForm()
    var wineId: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.mwPrimaryAppearance()
        
        editWineService = EditWineService(
            wineRepository: try! JFContainer.shared.container.resolve(),
            wineTypeRepository: try! JFContainer.shared.container.resolve(),
            imageWorker: try! JFContainer.shared.container.resolve()
        )
        
        form = wineForm.makeWineForm()
        
        wineForm.varietyRow.hidden = Condition.function(["type"], { form in
            if let value = self.wineForm.typeRow.value {
                return value.varieties.count == 0
            } else {
                return true
            }
        })
        
        wineForm.deleteButtonRow.onCellSelection { cell, row in
            self.showDeleteConfirmation()
        }
        
        firstly {
            self.editWineService.getWineTypes()
        }.done { wineTypes in
            self.wineForm.typeRow.options = wineTypes
        }.catch { error in
            SwiftyBeaver.error("\(error)")
        }
        
        firstly {
            self.editWineService.getWine(wineId: self.wineId)
        }.done { wine in
            self.displayWine(wine)
        }.catch { error in
            SwiftyBeaver.error("\(error)")
            self.displayErrorLoadingWine(error)
        }
        
        editWineService.getWinePhoto(wineId: wineId) { result in
            switch result {
            case .success(let photo): self.displayPhoto(photo)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Display Wine
    
    func displayWine(_ wineViewModel: WineViewModel) {
        wineForm.typeRow.value = wineForm.typeRow.options?.first(where: { $0.name == wineViewModel.typeName })
        
        wineForm.nameRow.value = wineViewModel.name
        wineForm.ratingRow.value = wineViewModel.rating
        wineForm.varietyRow.value = wineViewModel.variety
        wineForm.locationRow.value = wineViewModel.location
        wineForm.priceRow.value = wineViewModel.price
        wineForm.noteRow.value = wineViewModel.notes
        
        wineForm.varietyRow.evaluateHidden()
        
        for (index, name) in wineViewModel.pairings.enumerated() {
            let newRow = NameRow("pairing_\(index + 1)") {
                $0.placeholder = "e.g. Sushi, Cheese, etc"
                $0.value = name
            }
            wineForm.pairingsSection.insert(newRow, at: index)
        }
        
        tableView?.reloadData()
    }
    
    func displayPhoto(_ photo: UIImage?) {
        wineForm.photoRow.value = photo
        wineForm.photoRow.updateCell()
    }
    
    func displayErrorLoadingWine(_ error: Error) {
        
    }
    
    // MARK: - Save Wine
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let valuesDictionary = form.values()
        
        guard let name = valuesDictionary["name"] as? String else {
            return
        }
        guard let rating = valuesDictionary["rating"] as? Double else {
            return
        }
        guard let type = valuesDictionary["type"] as? WineTypeViewModel else {
            return
        }
        
        let variety = valuesDictionary["variety"] as? String
        let location = valuesDictionary["location"] as? String
        let price = valuesDictionary["price"] as? String
        let notes = valuesDictionary["notes"] as? String
        
        var request = SaveWineRequest(name: name, rating: rating, type: type.name)
        request.variety = variety
        request.location = location
        request.price = price
        request.notes = notes
        
        request.image = valuesDictionary["photo"] as? UIImage
        
        for (name, value) in valuesDictionary {
            if name.hasPrefix("pairing_"), let food = value as? String {
                request.pairings.append(food)
            }
        }
        
        editWineService.saveWine(wineId: wineId, request: request) { result in
            switch result {
            case .success: self.onSaveSuccess()
            case .failure(let error): self.onSaveError(error)
            }
        }
    }
    
    func onSaveSuccess() {
        dismiss(animated: true, completion: nil)
    }
    
    func onSaveError(_ error: Error) {
        
    }
    
    // MARK: - Delete Wine
    
    func showDeleteConfirmation() {
        let alertController = UIAlertController(title: "Are you sure?", message: "This cannot be undone.", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete Wine", style: .destructive, handler: { _ in self.deleteWine() }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteWine() {
        editWineService.deleteWine(wineId: wineId) { result in
            switch result {
            case .success: self.onDeleteSuccess()
            case .failure(let error): self.onDeleteError(error)
            }
        }
    }
    
    private func onDeleteSuccess() {
        performSegue(withIdentifier: "MyWines", sender: nil)
    }
    
    private func onDeleteError(_ error: Error) {
        showAlert(error: error)
    }
}

// MARK: - EditWineService

class EditWineService {
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
