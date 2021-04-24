//
//  FakeEditWineService.swift
//  mowine
//
//  Created by Josh Freed on 1/31/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import UIKit
import PromiseKit
import Model

class FakeEditWineService: EditWineService {
    func getWine(wineId: String) -> Promise<WineViewModel> {
        Promise<WineViewModel> { seal in
            
        }
    }
    
    func getWineTypes() -> Promise<[WineTypeViewModel]> {
        Promise<[WineTypeViewModel]> { seal in
            
        }
    }
    
    func getWine(wineId: String, completion: @escaping (Swift.Result<Wine, Error>) -> Void) {
    }
    
    func getWineTypes(completion: @escaping (Swift.Result<[WineType], Error>) -> Void) {
    }
    
    func getWinePhoto(wineId: String, completion: @escaping (Swift.Result<UIImage?, Error>) -> ()) {
        
    }
    
    func saveWine(wineId: String, request: SaveWineRequest, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        
    }
    
    func updateWine(wine: Wine, from request: SaveWineRequest, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        
    }
    
    func deleteWine(wineId: String, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        
    }
}
