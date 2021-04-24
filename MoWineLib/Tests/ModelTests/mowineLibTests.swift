import XCTest
@testable import mowineLib

final class mowineLibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(mowineLib().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
