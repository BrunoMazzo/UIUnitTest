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
        
        let somethingButton = try await app.buttons["Something"]
        let isHittable = try await somethingButton.isHittable
        XCTAssert(isHittable)
        
        try await somethingButton.tap()
        
        let exists = try await app.staticTexts["Something View"].exists
        
        XCTAssert(exists)
    }
    
    @MainActor
    func testExists() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.buttons["Hello world button"].tap()
        
        let exists = try await app.staticTexts["Value: Hello world"].exists
        
        XCTAssert(exists)
    }
    
    @MainActor
    func testDoubleTap() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.staticTexts["Double tap"].doubleTap()
        
        let exists = try await app.staticTexts["Value: Double tap"].exists
        
        XCTAssert(exists)
    }
    
    
    @MainActor
    func testEnterText() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try! await app.buttons["TextField"].tap()
        
        try! await app.textFields["TextField-Default"].tap()
        
        try! await app.textFields["TextField-Default"].enterText("Hello world")
        
        let exists = try! await app.staticTexts["Text value: Hello world"].exists
        
        XCTAssert(exists)
    }
    
    @MainActor
    func testSwipeActions() async throws {
        let app = try await App()
        
        showView(SwipeView())
        
        let noSwipeLabel = try await app.staticTexts["Direction: No swipe detected"].exists
        XCTAssert(noSwipeLabel)
        
        try await app.staticTexts["Swipe me"].swipeUp()
        var exists = try await app.staticTexts["Direction: Up"].exists
        XCTAssert(exists)
        
        try await app.staticTexts["Swipe me"].swipeDown()
        exists = try await app.staticTexts["Direction: Down"].exists
        XCTAssert(exists)
        
        try await app.staticTexts["Swipe me"].swipeLeft()
        exists = try await app.staticTexts["Direction: Left"].exists
        XCTAssert(exists)
        
        try await app.staticTexts["Swipe me"].swipeRight()
        exists = try await app.staticTexts["Direction: Right"].exists
        XCTAssert(exists)
    }
    
    @MainActor
    func testWaitForExistence() async throws {
        let app = try await App()
        
        showView(WaitForExistenceView())
        
        let messageExists = try await app.staticTexts["Hello world!"].exists
        XCTAssert(messageExists == false)
        
        try await app.buttons["Show Message"].tap()
        
        let messageExistsAfterShow = try await app.staticTexts["Hello world!"].waitForExistence(timeout: 2)
        XCTAssert(messageExistsAfterShow == true)
        
    }

    
    @MainActor
    func testPressWithDuration() async throws {
        let app = try await App()
        
        showView(PressAndHoldView())
        
        let messageExists = try await app.staticTexts["Hello world!"].exists
        XCTAssert(messageExists == false)
        
        try await app.staticTexts["Press and hold"].press(forDuration: 2.5)
        
        let messageExistsAfterShow = try await app.staticTexts["Hello world!"].exists
        XCTAssert(messageExistsAfterShow == true)
        
    }
    
    @MainActor
    func testHomeButtonAndLaunch() async throws {
        let app = try await App()
        
        showView(GoToBackgroundAndBackView())
        
        let wasntInBackgroud = try await app.staticTexts["WasInBackground: false"].exists
        XCTAssert(wasntInBackgroud == true)
        
        try await app.pressHomeButton()
        try await app.activate()
        
        let wasntInBackgroudAfterBackground = try await app.staticTexts["WasInBackground: true"].waitForExistence(timeout: 1)
        XCTAssert(wasntInBackgroudAfterBackground == true)
        
    }
    
    @MainActor
    func testTwoFingerTap() async throws {
        let app = try await App()
        
        showView(TapView())
        
        try await app.otherElements["TwoFingersView"].twoFingerTap()
        
        let wasntInBackgroudAfterBackground = try await app.staticTexts["Two fingers tapped"].waitForExistence(timeout: 1)
        XCTAssert(wasntInBackgroudAfterBackground == true)
        
    }
    
    @MainActor
    func testThreeFingerTap() async throws {
        let app = try await App()
        
        showView(TapView())
        
        try await app.otherElements["ThreeFingersView"].tap(withNumberOfTaps: 1, numberOfTouches: 3)
        
        let wasntInBackgroudAfterBackground = try await app.staticTexts["Three fingers tapped"].waitForExistence(timeout: 1)
        XCTAssert(wasntInBackgroudAfterBackground == true)
        
    }
    
    @MainActor
    func testPinch() async throws {
        let app = try await App()
        
        showView(PinchView())
        
        let didNotScale = try await app.staticTexts["Did scale? No"].exists
        XCTAssert(didNotScale)
        
        try await app.staticTexts["PinchContainer"].pinch(withScale: 1.5, velocity: 1)
        
        let didScale = try await app.staticTexts["Did scale? Yes"].waitForExistence(timeout: 1)
        XCTAssert(didScale == true)
    }
    
    @MainActor
    func testRotate() async throws {
        let app = try await App()
        
        showView(RotateView())
        
        let didNotRotate = try await app.staticTexts["Did rotate? No"].exists
        XCTAssert(didNotRotate)
        
        try await app.staticTexts["Rotate me!"].rotate(0.2, withVelocity: 1)
        
        let didRotate = try await app.staticTexts["Did rotate? Yes"].waitForExistence(timeout: 1)
        XCTAssert(didRotate)
    }
    
    
    
}
