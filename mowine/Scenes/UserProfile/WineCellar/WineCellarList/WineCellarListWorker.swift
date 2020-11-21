//
//  WineCellarListWorker.swift
//  mowine
//
//  Created by Josh Freed on 3/20/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class WineCellarListWorker {
    let wineRepository: WineRepository
    
    init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }
    
    func fetchWines(for userId: UserId, type: WineType, completion: @escaping (Result<[Wine], Error>) -> ()) {
        _ = wineRepository.getWines(userId: userId, wineType: type, completion: completion)
    }
}
