//
//  ClientTests.swift
//  ClientTests
//
//  Created by Bruno Mazzo on 5/3/2023.
//

import XCTest
import UIUnitTest
@testable import Client

final class ClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() async throws {
        await UI.activate()
        
        showView(MySettingTable())
        
        await UI().button(identifier: "Something").tap()
        
        let exists = await UI().staticText(label: "Something View").exists()
        
        XCTAssert(exists)
        
    }
    
    @MainActor
    func testExample2() async throws {
        await UI.activate()
        
        showView(MySettingTable())
        
        await UI().button(identifier: "Hello world button").tap()
        
        let exists = await UI().staticText(label: "Value: Hello world").exists()
        
        XCTAssert(exists)
    }

}
