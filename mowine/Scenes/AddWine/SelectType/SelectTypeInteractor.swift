//
//  SelectTypeInteractor.swift
//  mowine
//
//  Created by Josh Freed on 7/4/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SelectTypeBusinessLogic {
    func fetchWineTypes(request: SelectType.FetchTypes.Request)
    func selectType(request: SelectType.SelectType.Request)
}

protocol SelectTypeDataStore {
    var selectedType: ManagedWineType? { get }
}

class SelectTypeInteractor: SelectTypeBusinessLogic, SelectTypeDataStore {
    var presenter: SelectTypePresentationLogic?
    var wineTypesWorker: WineTypeWorker?
    var wineTypes: [ManagedWineType]?
    var selectedType: ManagedWineType?

    func fetchWineTypes(request: SelectType.FetchTypes.Request) {
        guard let wineTypes = wineTypesWorker?.getWineTypes() else {
            return
        }

        self.wineTypes = wineTypes
        
//        let response = SelectType.FetchTypes.Response(wineTypes: wineTypes)
//        presenter?.presentWineTypes(response: response)
    }
    
    func selectType(request: SelectType.SelectType.Request) {
        selectedType = getTypeFromString(request.type)
        
        if let type = selectedType {
            let response = SelectType.SelectType.Response(type: type)
            presenter?.presentSelectedType(response: response)
        }
    }
    
    func getTypeFromString(_ type: String) -> ManagedWineType? {
        return wineTypes?.first(where: { $0.name == type })
    }
}
