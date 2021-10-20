//
//  WineMappingTests.swift
//  mowineTests
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest
import Nimble
@testable import MoWine_Infrastructure
@testable import MoWine_Domain
@testable import MoWine_Domain_TestKit

class WineMappingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - toFirestore()
    
    func test_toFirestore_basic_properties() throws {
        let wine = WineBuilder.aWine()
            .withRating(4)
            .withName("My Great Wine")
            .withLocation("Wegmans")
            .withNotes("This tastes like wine")
            .pairedWith(["cheese", "sushi"])
            .withPrice("$5.99")
            .build()
        
        let data = wine.toFirestore()
        
        expect(data["userId"] as? String).to(equal(wine.userId.asString))
        expect(data["type"] as? String).to(equal(wine.type.name))
        expect(data["name"] as? String).to(equal("My Great Wine"))
        expect(data["rating"] as? Double).to(equal(4))
        expect(data["createdAt"] as? String).to(equal(ISO8601DateFormatter().string(from: wine.createdAt)))
        expect(data["pairings"] as? [String]).to(equal(["cheese", "sushi"]))
        expect(data["location"] as? String).to(equal("Wegmans"))
        expect(data["notes"] as? String).to(equal("This tastes like wine"))
        expect(data["price"] as? String).to(equal("$5.99"))
    }
    
    func test_toFirestore_variety() throws {
        let wine = WineBuilder.aWine()
            .withVariety(WineVariety(name: "Merlot"))
            .build()
        
        let data = wine.toFirestore()
        
        expect(data["variety"] as? String).to(equal("Merlot"))
    }
    
    func test_toFirestore_nil_variety() throws {
        let wine = WineBuilder.aWine()
            .withVariety(nil)
            .build()
        
        let data = wine.toFirestore()
        
        expect(data.keys).to(contain("variety"))
        expect(data["variety"] as? String).to(beNil())
    }
}
