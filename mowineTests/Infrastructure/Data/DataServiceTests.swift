//
//  DataServiceTests
//  mowineTests
//
//  Created by Josh Freed on 4/10/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import Nimble

class DataServiceTests: XCTestCase {
    var sut: DataService<MockRead, MockWrite>!
    let mockRead = MockRead()
    let mockWrite = MockWrite()
    var completionWasCalled = false
    var result: Result<Data?, Error>?
    var putResult: Result<URL, Error>?
    var data: Data!
    
    override func setUp() {
        sut = DataService(remoteRead: mockRead, remoteWrite: mockWrite)
        data = someData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Mocks
    
    class MockRead: DataReadService {
        var nextResult: Result<Data?, Error>? = .success(nil)
        var getDataWasCalled = false
        var getData_url: String?
        func getData(url: String, completion: @escaping (Result<Data?, Error>) -> ()) {
            getDataWasCalled = true
            getData_url = url
            completion(nextResult!)
        }
        
        func verifyGetDataWasCalled(with url: String) {
            expect(self.getDataWasCalled).to(beTrue())
            expect(self.getData_url).to(equal(url))
        }
        
        func verifyGetDataWasNeverCalled() {
            expect(self.getDataWasCalled).to(beFalse())
        }
    }
    
    class MockWrite: DataWriteService {
        var nextResult: Result<URL, Error>? = .success(URL(fileURLWithPath: "/"))
        var putDataWasCalled = false
        var putData_data: Data?
        var putData_url: String?
        
        func putData(_ data: Data, url: String, completion: @escaping (Result<URL, Error>) -> ()) {
            putDataWasCalled = true
            putData_data = data
            putData_url = url
            completion(nextResult!)
        }
        
        func verifyPutDataWasCalled(data: Data, url: String) {
            expect(self.putDataWasCalled).to(beTrue())
            expect(self.putData_data).to(equal(data))
            expect(self.putData_url).to(equal(url))
        }
    }

    // MARK: - Tests
    
    // MARK: getData
    
    func test_getData_notCached_remoteReturnsNil() {
        mockRead.nextResult = .success(nil)
        
        getData(url: "image1")
        
        mockRead.verifyGetDataWasCalled(with: "image1")
        expect(self.completionWasCalled).to(beTrue())
        expect(self.result).to(beSuccess(test: { data in
            expect(data).to(beNil())
        }))
    }
    
    func test_getData_notCached_fetchDataFromRemote() {
        mockRead.nextResult = .success(data)
        
        getData(url: "image1")
        
        mockRead.verifyGetDataWasCalled(with: "image1")
        expect(self.completionWasCalled).to(beTrue())
        expect(self.result).to(beSuccess(test: { actual in
            expect(actual).to(equal(self.data))
        }))
    }
    
    func test_getData_cachesDataAfterFetching() {
        mockRead.nextResult = .success(data)
        
        getData(url: "image1")
        
        expectCacheToContain(data: data, forKey: "image1")        
    }
    
    func test_getData_returns_data_from_cache_if_present() {
        let url = "image1"
        sut.dataCache.setObject(data as NSData, forKey: url as NSString)
        
        getData(url: url)
        
        expect(self.completionWasCalled).to(beTrue())
        expect(self.result).to(beSuccess(test: { actual in
            expect(actual).to(equal(self.data))
        }))
        mockRead.verifyGetDataWasNeverCalled()
    }
    
    // MARK: putData
    
    func test_putData_adds_data_to_cache() {
        let url = "image1"
        
        putData(data, url: "image1")
        
        expectCacheToContain(data: data, forKey: url)
    }
    
    func test_putData_sends_the_data_to_the_remote_storage() {
        let url = "image1"
        
        putData(data, url: "image1")
        
        mockWrite.verifyPutDataWasCalled(data: data, url: url)
        expect(self.completionWasCalled).to(beTrue())
        expect(self.putResult).to(beSuccess())
    }
    
    // MARK: - Helpers
    
    private func someData() -> Data {
        return Data(repeating: 1, count: 100)
    }
    
    private func getData(url: String) {
        sut.getData(url: "image1") { r in
            self.completionWasCalled = true
            self.result = r
        }
    }
    
    private func putData(_ data: Data, url: String) {
        sut.putData(data, url: url) { r in
            self.completionWasCalled = true
            self.putResult = r
        }
    }
    
    private func expectCacheToContain(data: Data, forKey key: String) {
        let cached = sut.dataCache.object(forKey: key as NSString)
        expect(cached).toNot(beNil())
        if let cached = cached {
            expect(cached as Data).to(equal(data))
        }
    }
}
