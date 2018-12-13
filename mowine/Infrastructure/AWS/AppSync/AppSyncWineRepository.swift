//
//  AppSyncWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 11/20/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import AWSAppSync
import JFLib
import SwiftyBeaver

class AppSyncWineRepository: WineRepository {
    let appSyncClient: AWSAppSyncClient
    
    init(appSyncClient: AWSAppSyncClient) {
        self.appSyncClient = appSyncClient
    }
    
    func add(_ wine: Wine, completion: @escaping (JFLib.Result<Wine>) -> ()) {
        var input = CreateWineInput(id: wine.id.asString, type: wine.type.name, name: wine.name, rating: Int(wine.rating), pairings: [])
        input.wineUserId = wine.userId.asString
        input.location = wine.location
        input.notes = wine.notes
        input.price = wine.price
        input.variety = wine.variety?.name
        
        appSyncClient.perform(mutation: CreateWineMutation(input: input), optimisticUpdate: { transaction in
            SwiftyBeaver.info("This is pretty optimistic!!!")
            
            do {
                try transaction?.update(query: GetUserQuery(id: wine.userId.asString)) { (data: inout GetUserQuery.Data) in
                    let item = GetUserQuery.Data.GetUser.Wine.Item.fromWine(wine)
                    data.getUser?.wines?.items?.append(item)
                }
                DispatchQueue.main.async {
                    completion(.success(wine))
                }
            } catch {
                SwiftyBeaver.error("\(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }, resultHandler: { result, error in
            SwiftyBeaver.debug("CreateWine result handler called")
            
            if let error = error as? AWSAppSyncClientError {
                SwiftyBeaver.error("Error occurred: \(error.localizedDescription )")
                return
            }
            if let resultError = result?.errors {
                SwiftyBeaver.error("Error saving the item on server: \(resultError)")
                return
            }
        })
    }
    
    func save(_ wine: Wine, completion: @escaping (JFLib.Result<Wine>) -> ()) {
        var input = UpdateWineInput(id: wine.id.asString)
        input.type = wine.type.name
        input.name = wine.name
        input.rating = Int(wine.rating)
        input.pairings = wine.pairings
        input.location = wine.location
        input.notes = wine.notes
        input.price = wine.price
        input.variety = wine.variety?.name
        
        appSyncClient.perform(mutation: UpdateWineMutation(input: input), optimisticUpdate: { transaction in
            SwiftyBeaver.debug("UpdateWineMutation optimistic update")
            do {
                try transaction?.update(query: GetUserQuery(id: wine.userId.asString)) { (data: inout GetUserQuery.Data) in
                    let item = GetUserQuery.Data.GetUser.Wine.Item.fromWine(wine)
                    data.getUser?.wines?.items?.append(item)
                }
                DispatchQueue.main.async {
                    completion(.success(wine))
                }
            } catch {
                SwiftyBeaver.error("\(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }, resultHandler: { result, error in
            SwiftyBeaver.debug("UpdateWine result handler called")
            if let error = error as? AWSAppSyncClientError {
                SwiftyBeaver.error("Error occurred: \(error.localizedDescription )")
                return
            }
            if let resultError = result?.errors {
                SwiftyBeaver.error("Error saving the item on server: \(resultError)")
                return
            }
        })
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        let input = DeleteWineInput(id: wine.id.asString)
        appSyncClient.perform(mutation: DeleteWineMutation(input: input)) { result, error in
            if let error = error as? AWSAppSyncClientError {
                SwiftyBeaver.error("Error occurred: \(error.localizedDescription )")
                completion(.failure(error))
                return
            }
            if let resultError = result?.errors {
                SwiftyBeaver.error("Error deleting the item on server: \(resultError)")
                completion(.failure(resultError.first!))
                return
            }
            completion(.success)
        }
    }
    
    func getWine(by id: WineId, completion: @escaping (JFLib.Result<Wine>) -> ()) {
        appSyncClient.fetch(query: GetWineQuery(id: id.asString), cachePolicy: .returnCacheDataAndFetch) { result, error in
            SwiftyBeaver.debug("GetWineQuery result handler \(id)")
            
            if let error = error {
                SwiftyBeaver.error("\(error)")
                SwiftyBeaver.error(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            if let errors = result?.errors, let firstError = errors.first {
                SwiftyBeaver.error("Result had \(errors.count) errors")
                SwiftyBeaver.error("\(errors)")
                completion(.failure(firstError))
                return
            }
            
            guard let getWine = result?.data?.getWine else {
                completion(.failure(WineRepositoryError.notFound))
                return
            }
            
            let wine = getWine.toWine()
            completion(.success(wine))
        }        
    }
    
    func getWines(userId: UserId, completion: @escaping (JFLib.Result<[Wine]>) -> ()) {
        SwiftyBeaver.debug("getWines for \(userId)")
        
        appSyncClient.fetch(query: GetUserQuery(id: userId.asString), cachePolicy: .returnCacheDataAndFetch) { (result, error) in
            SwiftyBeaver.debug("getWines GetUserQuery Complete")
            
            if error != nil {
                SwiftyBeaver.error(error?.localizedDescription ?? "")
                completion(.failure(error!))
                return
            }
            
            if let appSyncWines = result?.data?.getUser?.wines?.items {
                let wines = appSyncWines.compactMap { $0?.toWine(userId: userId) }
                completion(.success(wines))
            } else {
                completion(.success([]))
            }
        }
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (JFLib.Result<[Wine]>) -> ()) {
        getWines(userId: userId) { result in
            switch result {
            case .success(let wines):
                let winesOfType = wines.filter { $0.type == wineType }
                completion(.success(winesOfType))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTopWines(userId: UserId, completion: @escaping (JFLib.Result<[Wine]>) -> ()) {
        getWines(userId: userId) { result in
            switch result {
            case .success(let wines):
                let slice = wines
                    .sorted(by: { $0.rating > $1.rating })
                    .prefix(3)
                let topWines: [Wine] = Array(slice)
                completion(.success(topWines))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension GetUserQuery.Data.GetUser.Wine.Item {
    static func fromWine(_ wine: Wine) -> GetUserQuery.Data.GetUser.Wine.Item {
        var item = GetUserQuery.Data.GetUser.Wine.Item(
            id: wine.id.asString,
            type: wine.type.name,
            name: wine.name,
            rating: Int(wine.rating),
            pairings: wine.pairings
        )
        item.location = wine.location
        item.notes = wine.notes
        item.price = wine.price
        item.variety = wine.variety?.name
        return item
    }
    
    func toWine(userId: UserId) -> Wine {
        let wineId = WineId(string: id)
        let wineType = WineType(name: type, varieties: [])
        let wine = Wine(id: wineId, userId: userId, type: wineType, name: name, rating: Double(rating))
        
        if let varietyName = variety {
            wine.variety = WineVariety(name: varietyName)
        }
        
        wine.location = location
        wine.notes = notes
        wine.price = price
        wine.pairings = pairings
        
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let createdAtStr = createdAt, let date = df.date(from: createdAtStr) {
            wine.createdAt = date
        }
        
        return wine
    }
}

extension OnCreateWineSubscription.Data.OnCreateWine {
    func toWine() -> Wine {
        let wineId = WineId(string: id)
        let userId = UserId(string: user?.id ?? "")
        let wineType = WineType(name: type, varieties: [])
        let wine = Wine(id: wineId, userId: userId, type: wineType, name: name, rating: Double(rating))
        
        if let varietyName = variety {
            wine.variety = WineVariety(name: varietyName)
        }
        
        wine.location = location
        wine.notes = notes
        wine.price = price
        wine.pairings = pairings
        
        return wine
    }
}

extension GetWineQuery.Data.GetWine {
    func toWine() -> Wine {
        let wineId = WineId(string: id)
        let userId = UserId(string: user?.id ?? "")
        let wineType = WineType(name: type, varieties: [])
        let wine = Wine(id: wineId, userId: userId, type: wineType, name: name, rating: Double(rating))
        
        if let varietyName = variety {
            wine.variety = WineVariety(name: varietyName)
        }
        
        wine.location = location
        wine.notes = notes
        wine.price = price
        wine.pairings = pairings
        
        return wine
    }
}
