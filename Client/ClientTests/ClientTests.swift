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

    @MainActor
    func testTap() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.button(identifier: "Something").tap()
        
        let exists = try await app.staticText(label: "Something View").exists()
        
        XCTAssert(exists)
    }
    
    @MainActor
    func testExists() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.button(identifier: "Hello world button").tap()
        
        let exists = try await app.staticText(label: "Value: Hello world").exists()
        
        XCTAssert(exists)
    }
    
    @MainActor
    func testDoubleTap() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.staticText(label: "Double tap").doubleTap()
        
        let exists = try await app.staticText(label: "Value: Double tap").exists()
        
        XCTAssert(exists)
    }
    
    
    @MainActor
    func testEnterText() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.button(identifier: "TextField").tap()
        
        try await app.textField(identifier: "TextField-Default").tap()
        
        try await app.textField(identifier: "TextField-Default").enterText("Hello world")
        
        let exists = try await app.staticText(label: "Text value: Hello world").exists()
        
        XCTAssert(exists)
    }
    
    @MainActor
    func testSwipeActions() async throws {
        let app = try await App()
        
        showView(SwipeView())
        
        let noSwipeLabel = try await app.staticText(label: "Direction: No swipe detected").exists()
        XCTAssert(noSwipeLabel)
        
        try await app.staticText(label: "Swipe me").swipeUp()
        var exists = try await app.staticText(label: "Direction: Up").exists()
        XCTAssert(exists)
        
        try await app.staticText(label: "Swipe me").swipeDown()
        exists = try await app.staticText(label: "Direction: Down").exists()
        XCTAssert(exists)
        
        try await app.staticText(label: "Swipe me").swipeLeft()
        exists = try await app.staticText(label: "Direction: Left").exists()
        XCTAssert(exists)
        
        try await app.staticText(label: "Swipe me").swipeRight()
        exists = try await app.staticText(label: "Direction: Right").exists()
        XCTAssert(exists)
    }

}
