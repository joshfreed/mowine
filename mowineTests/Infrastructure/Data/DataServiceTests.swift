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
    var result: Data?
    var putResult: URL?
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
        var nextResult: Result<Data?, Error> = .success(nil)
        var getDataWasCalled = false
        var getData_url: String?
        func getData(url: String) async throws -> Data? {
            getDataWasCalled = true
            getData_url = url
            switch nextResult {
            case .success(let data): return data
            case .failure(let error): throw error
            }
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
        var nextResult: Result<URL, Error> = .success(URL(fileURLWithPath: "/"))
        var putDataWasCalled = false
        var putData_data: Data?
        var putData_url: String?
        
        func putData(_ data: Data, url: String) async throws -> URL {
            putDataWasCalled = true
            putData_data = data
            putData_url = url
            switch nextResult {
            case .success(let url): return url
            case .failure(let error): throw error
            }
        }
        
        func verifyPutDataWasCalled(data: Data, url: String) {
            expect(self.putDataWasCalled).to(beTrue())
            expect(self.putData_data).to(equal(data))
            expect(self.putData_url).to(equal(url))
        }
    }

    // MARK: - Tests
    
    // MARK: getData
    
    func test_getData_notCached_remoteReturnsNil() async throws {
        mockRead.nextResult = .success(nil)
        
        let data = try await getData(url: "image1")
        
        mockRead.verifyGetDataWasCalled(with: "image1")
        expect(data).to(beNil())
    }
    
    func test_getData_notCached_fetchDataFromRemote()async throws  {
        mockRead.nextResult = .success(data)
        
        let actual = try await getData(url: "image1")
        
        mockRead.verifyGetDataWasCalled(with: "image1")
        expect(actual).to(equal(self.data))
    }
    
    func test_getData_cachesDataAfterFetching() async throws {
        mockRead.nextResult = .success(data)
        
        _ = try await getData(url: "image1")
        
        expectCacheToContain(data: data, forKey: "image1")        
    }
    
    func test_getData_returns_data_from_cache_if_present() async throws {
        let url = "image1"
        sut.dataCache.setObject(data as NSData, forKey: url as NSString)
        
        let actual = try await getData(url: url)
        
        expect(actual).to(equal(self.data))
        mockRead.verifyGetDataWasNeverCalled()
    }
    
    // MARK: putData
    
    func test_putData_adds_data_to_cache() async throws {
        let url = "image1"
        
        _ = try await putData(data, url: "image1")
        
        expectCacheToContain(data: data, forKey: url)
    }
    
    func test_putData_sends_the_data_to_the_remote_storage() async throws {
        let url = "image1"
        
        _ = try await putData(data, url: "image1")
        
        mockWrite.verifyPutDataWasCalled(data: data, url: url)
    }
    
    // MARK: - Helpers
    
    private func someData() -> Data {
        return Data(repeating: 1, count: 100)
    }
    
    private func getData(url: String) async throws -> Data? {
        try await sut.getData(url: url)
    }
    
    private func putData(_ data: Data, url: String) async throws -> URL {
        try await sut.putData(data, url: url)
    }
    
    private func expectCacheToContain(data: Data, forKey key: String) {
        let cached = sut.dataCache.object(forKey: key as NSString)
        expect(cached).toNot(beNil())
        if let cached = cached {
            expect(cached as Data).to(equal(data))
        }
    }
}
