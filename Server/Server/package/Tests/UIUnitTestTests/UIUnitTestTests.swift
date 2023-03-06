import XCTest
@testable import UIUnitTest

final class UIUnitTestTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UIUnitTest().text, "Hello, World!")
    }
}
