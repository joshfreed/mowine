//
//  WineCellarWorker.swift
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

class WineCellarWorker {
    let wineTypeRepository: WineTypeRepository
    let userRepository: UserRepository
    let wineRepository: WineRepository
    
    init(wineTypeRepository: WineTypeRepository, userRepository: UserRepository, wineRepository: WineRepository) {
        self.wineTypeRepository = wineTypeRepository
        self.userRepository = userRepository
        self.wineRepository = wineRepository
    }
    
    func getUser(by userId: UserId, completion: @escaping (Result<User?, Error>) -> ()) {
        userRepository.getUserById(userId, completion: completion)
    }
    
    func getWineTypes(for userId: UserId, completion: @escaping (Result<[WineType], Error>) -> ()) {
        wineRepository.getWineTypeNamesWithAtLeastOneWineLogged(userId: userId) { result in
            switch result {
            case .success(let wineTypeNames): self.convertToWineTypes(wineTypeNames, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func convertToWineTypes(_ wineTypeNames: [String], completion: @escaping (Result<[WineType], Error>) -> ()) {
        wineTypeRepository.getAll { result in
            switch result {
            case .success(let allWineTypes):
                let userWineTypes = allWineTypes.filter { wineTypeNames.contains($0.name) }
                completion(.success(userWineTypes))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}