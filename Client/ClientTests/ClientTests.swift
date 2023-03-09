//
//  ClientTests.swift
//  ClientTests
//
//  Created by Bruno Mazzo on 5/3/2023.
//

import XCTest
import UIUnitTest
@testable import Client

extension App {
    convenience init() async throws {
        try await self.init(appId: "bruno.mazzo.Client")
    }
}

final class ClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.button(identifier: "Something").tap()
        
        let exists = try await app.staticText(label: "Something View").exists()
        
        XCTAssert(exists)
        
    }
    
    @MainActor
    func testExample2() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.button(identifier: "Hello world button").tap()
        
        let exists = try await app.staticText(label: "Value: Hello world").exists()
        
        XCTAssert(exists)
    }
    
    
    @MainActor
    func testExample3() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.button(identifier: "TextField").tap()
        
        try await app.textField(identifier: "TextField-Default").tap()
        
        try await app.textField(identifier: "TextField-Default").enterText("Hello world")
        
        XCTAssert(true)
    }

}
