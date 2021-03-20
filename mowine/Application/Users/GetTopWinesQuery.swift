//
//  GetTopWinesQuery.swift
//  mowine
//
//  Created by Josh Freed on 3/7/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver

class GetTopWinesQuery {
    var result: AnyPublisher<Response, Error> {
        publisher.eraseToAnyPublisher()
    }

    private let wineRepository: WineRepository
    private let publisher = PassthroughSubject<Response, Error>()

    init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    func execute(userId: String) {
        wineRepository.getTopWines(userId: UserId(string: userId)) { [weak self] result in
            switch result {
            case .success(let topWines):
                let mappedWines = topWines.map {
                    TopWine(id: $0.id.asString, name: $0.name, rating: Int($0.rating), type: $0.type.name)
                }
                let response = Response(topWines: mappedWines)
                self?.publisher.send(response)
            case .failure(let error):
                self?.publisher.send(completion: .failure(error))
            }
        }
    }
}

extension GetTopWinesQuery {
    struct Response {
        let topWines: [TopWine]
    }

    struct TopWine {
        let id: String
        let name: String
        let rating: Int
        let type: String
    }
}
