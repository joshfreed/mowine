//
//  NimbleMatchers.swift
//  mowineTests
//
//  Created by Josh Freed on 11/9/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import XCTest
import Nimble

extension XCTestCase {
    func beSuccess<T>(test: @escaping (T) -> Void = { _ in }) -> Predicate<Result<T, Error>> {
        return Predicate.define("be <success>") { expression, message in
            if let actual = try expression.evaluate(), case let .success(response) = actual {
                test(response)
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
    
    func beSuccess() -> Predicate<Result<Void, Error>> {
        return Predicate.define("be <success>") { expression, message in
            if let actual = try expression.evaluate(), case .success = actual {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
    
    func beFailure<T>(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Result<T, Error>> {
        return Predicate.define("be <failure>") { expression, message in
            if let actual = try expression.evaluate(), case let .failure(error) = actual {
                test(error)
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
    
    func beFailure(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Result<Void, Error>> {
        return Predicate.define("be <failure>") { expression, message in
            if let actual = try expression.evaluate(), case let .failure(error) = actual {
                test(error)
                return PredicateResult(status: .matches, message: message)
            } else {
                return PredicateResult(status: .fail, message: message)
            }
        }
    }
}
