//
//  UIUnitTestUITests.swift
//  UIUnitTestUITests
//
//  Created by Bruno Mazzo on 5/3/2023.
//

import XCTest

final class UITestServerTest: XCTestCase {
    
    override func record(_ issue: XCTIssue) {
        self.server.lastIssue = issue
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    var server: UIServer!

    @MainActor
    func testStart() async throws {
        self.server = UIServer()
        
        do {
            try await self.server.start()
        } catch {
            print("SERVER ERROR ----------------------------------")
            print(error.localizedDescription)
            print("SERVER ERROR ----------------------------------")
        }
    }
}
