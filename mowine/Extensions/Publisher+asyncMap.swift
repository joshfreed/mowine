//
//  Publisher+asyncMap.swift
//  mowine
//
//  Created by Josh Freed on 10/31/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    func asyncMap<T>(_ transform: @escaping (Output) async throws -> T) -> Publishers.FlatMap<Future<T, Error>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}
