//
//  WineCellarInteractor.swift
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

protocol WineCellarBusinessLogic {
    func getWineTypes(request: WineCellar.GetWineTypes.Request)
    func selectType(request: WineCellar.SelectType.Request)
}

protocol WineCellarDataStore {
    var userId: UserId! { get set }
    var user: User? { get }
    var selectedType: WineType? { get }
}

class WineCellarInteractor: WineCellarBusinessLogic, WineCellarDataStore {
    var presenter: WineCellarPresentationLogic?
    var worker: WineCellarWorker?
    var userId: UserId!
    var user: User?
    var types: [WineType] = []
    var selectedType: WineType?

    // MARK: Get wine types

    func getWineTypes(request: WineCellar.GetWineTypes.Request) {
        worker?.getUser(by: userId) { userResult in
            switch userResult {
            case .success(let user):
                self.user = user
                self.getWineTypes2(request: request)
            case .failure(let error): print("\(error)")
            }            
        }
    }
    
    private func getWineTypes2(request: WineCellar.GetWineTypes.Request) {
        worker?.getWineTypes() { result in
            switch result {
            case .success(let types):
                self.types = types
                let response = WineCellar.GetWineTypes.Response(types: types)
                self.presenter?.presentWineTypes(response: response)
            case .failure(let error): print("\(error)")
            }
        }
    }
    
    // MARK: Select type
    
    func selectType(request: WineCellar.SelectType.Request) {
        selectedType = types.first(where: { $0.name == request.type })
        
        let response = WineCellar.SelectType.Response()
        presenter?.presentSelectedType(response: response)
    }
}
