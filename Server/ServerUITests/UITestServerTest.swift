//
//  UIUnitTestUITests.swift
//  UIUnitTestUITests
//
//  Created by Bruno Mazzo on 5/3/2023.
//

import XCTest

final class UITestServerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testStart() async throws {
        let server = UIServer()
        
        try await server.start()
    }
}
