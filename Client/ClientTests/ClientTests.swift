import XCTest
import UIUnitTest
@testable import Client

class ClientTests: XCTestCase {
    
    override func setUp() async throws {
        self.continueAfterFailure = false
        await UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func testTap() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        let somethingButton = try await app.buttons("Something")
        try await Assert(somethingButton.isHittable())
        
        try await somethingButton.tap()
        
        try await Assert(app.staticTexts("Something View").waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testExists() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await Assert(app.staticTexts("Hello world button").waitForExistence(timeout: 1))
        
        try await Assert(app.staticTexts("Hello world button").isHittable())
        
        try await app.buttons("Hello world button").tap()

        try await Assert(app.staticTexts("Value: Hello world").waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testDoubleTap() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await Assert(app.staticTexts("Double tap").waitForExistence(timeout: 1))
        
        try await app.staticTexts("Double tap").doubleTap()
        
        try await Assert(app.staticTexts("Value: Double tap").waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testEnterText() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.buttons("TextField").tap()
        
        try await app.textFields("TextField-Default").tap()
        
        try await app.textFields("TextField-Default").typeText("Hello world")
        
        try await Assert(app.staticTexts("Text value: Hello world").waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testSwipeActions() async throws {
        let app = try await App()
        
        showView(SwipeView())
        
        try await Assert(app.staticTexts("Direction: No swipe detected").exists())
        
        try await app.staticTexts("Swipe me").swipeUp()
        try await Assert(app.staticTexts("Direction: Up").exists())
        
        try await app.staticTexts("Swipe me").swipeDown()
        try await Assert(app.staticTexts("Direction: Down").exists())
        
        try await app.staticTexts("Swipe me").swipeLeft()
        try await Assert(app.staticTexts("Direction: Left").exists())
        
        try await app.staticTexts("Swipe me").swipeRight()
        try await Assert(app.staticTexts("Direction: Right").exists())
        
        try await app.staticTexts("Swipe me").swipeUp(velocity: 100)
        try await Assert(app.staticTexts("Direction: Up").exists())
        
        try await app.staticTexts("Swipe me").swipeDown(velocity: 100.5)
        try await Assert(app.staticTexts("Direction: Down").exists())
        
        let velocityCGFloat: CGFloat = 500
        try await app.staticTexts("Swipe me").swipeLeft(velocity: GestureVelocity(velocityCGFloat))
        try await Assert(app.staticTexts("Direction: Left").exists())
        
        try await app.staticTexts("Swipe me").swipeRight(velocity: 600)
        try await Assert(app.staticTexts("Direction: Right").exists())
    }
    
    @MainActor
    func testWaitForExistence() async throws {
        let app = try await App()
        
        showView(WaitForExistenceView())
        
        try await Assert(app.staticTexts("Hello world!").exists() == false)
        
        try await app.buttons("Show Message").tap()
        
        try await Assert(app.staticTexts("Hello world!").waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testPressWithDuration() async throws {
        let app = try await App()
        
        showView(PressAndHoldView())
        
        try await Assert(app.staticTexts("Hello world!").exists() == false)
        
        try await app.staticTexts("Press and hold").press(forDuration: 2.5)
        
        try await Assert(app.staticTexts("Hello world!").exists())
    }

    @MainActor
    func testHomeButtonAndLaunch() async throws {
        let app = try await App()
        
        showView(GoToBackgroundAndBackView())
        
        try await Assert(app.staticTexts("WasInBackground: false").exists())
        
        try await app.pressHomeButton()
        try await app.activate()
        
        try await Assert(app.staticTexts("WasInBackground: true").waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testTwoFingerTap() async throws {
        let app = try await App()
        
        showView(TapView())
        
        try await Assert(app.otherElements("TwoFingersView").exists())
        try await app.otherElements("TwoFingersView").twoFingerTap()
        
        try await Assert(app.staticTexts("Two fingers tapped").waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testThreeFingerTap() async throws {
        let app = try await App()
        
        showView(TapView())
        
        try await app.otherElements("ThreeFingersView").tap(withNumberOfTaps: 1, numberOfTouches: 3)
        
        try await Assert(app.staticTexts("Three fingers tapped").waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testPinch() async throws {
        let app = try await App()
        
        showView(PinchView())
        
        try await Assert(app.staticTexts("Did scale? No").exists())
        
        try await app.staticTexts("PinchContainer").pinch(withScale: 1.5, velocity: 1)
        
        try await Assert(app.staticTexts("Did scale? Yes").waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testRotate() async throws {
        let app = try await App()
        
        showView(RotateView())
        
        try await Assert(app.staticTexts("Did rotate? No").exists())
        
        try await app.staticTexts("Rotate me!").rotate(0.2, withVelocity: 1)
        
        try await Assert(app.staticTexts("Did rotate? Yes").waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testMatchingWithPredicate() async throws {
        let app = try await App()
        
        showView(SomethingView())
        
        let somethingView = try await app.staticTexts().element(matching: NSPredicate(format: "label == %@", "SomethingViewAccessbilityLabel"))
        
        try await Assert(somethingView.exists())
    }
    
    @MainActor
    func testTapSync() {
        let app = App()
        
        showView(MySettingTable())
        
        let somethingButton = app.buttons["Something"]
        Assert(somethingButton.isHittable)
        
        somethingButton.tap()
        
        Assert(app.staticTexts["Something View"].waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testExistsSync() {
        let app = App()
        
        showView(MySettingTable())
        
        Assert(app.buttons["Hello world button"].waitForExistence(timeout: 1))
        
        app.buttons["Hello world button"].tap()
        
        Assert(app.staticTexts["Value: Hello world"].exists)
    }
    
    @MainActor
    func testDoubleTapSync() {
        let app = App()
        
        showView(MySettingTable())
        
        XCTAssert(app.staticTexts["Double tap"].waitForExistence(timeout: 1))
        
        app.staticTexts["Double tap"].doubleTap()
        
        Assert(app.staticTexts["Value: Double tap"].waitForExistence(timeout: 1))
    }
    
    @MainActor
    func testEnterTextSync() {
        let app = App()
        
        showView(MySettingTable())
        
        app.buttons["TextField"].assertElementExists().tap()
        
        app.textFields["TextField-Default"].assertElementExists().tap()
        
        app.textFields["TextField-Default"].typeText("Hello world")
        
        app.staticTexts["Text value: Hello world"].assertElementExists()
    }
    
    @MainActor
    func testSwipeActionsSync() {
        let app = App()
        
        showView(SwipeView())
        
        app.staticTexts["Direction: No swipe detected"].assertElementExists()
        
        app.staticTexts["Swipe me"].swipeUp()
        app.staticTexts["Direction: Up"].assertElementExists()
        
        app.staticTexts["Swipe me"].swipeDown()
        app.staticTexts["Direction: Down"].assertElementExists()
        
        app.staticTexts["Swipe me"].swipeLeft()
        app.staticTexts["Direction: Left"].assertElementExists()
        
        app.staticTexts["Swipe me"].swipeRight()
        app.staticTexts["Direction: Right"].assertElementExists()
        
        app.staticTexts["Swipe me"].swipeUp(velocity: 100)
        app.staticTexts["Direction: Up"].assertElementExists()
        
        app.staticTexts["Swipe me"].swipeDown(velocity: 100.5)
        app.staticTexts["Direction: Down"].assertElementExists()
        
        let velocityCGFloat: CGFloat = 500
        app.staticTexts["Swipe me"].swipeLeft(velocity: GestureVelocity(velocityCGFloat))
        app.staticTexts["Direction: Left"].assertElementExists()
        
        app.staticTexts["Swipe me"].swipeRight(velocity: 600)
        app.staticTexts["Direction: Right"].assertElementExists()
    }
    
    @MainActor
    func testWaitForExistenceSync() {
        let app = App()
        
        showView(WaitForExistenceView())
        
        Assert(app.staticTexts["Hello world!"].exists == false)
        
        app.buttons["Show Message"].assertElementExists().tap()
        
        app.staticTexts["Hello world!"].assertElementExists(timeout: 2)
    }
    
    @MainActor
    func testPressWithDurationSync() {
        let app = App()
        
        showView(PressAndHoldView())
        
        Assert(app.staticTexts["Hello world!"].exists == false)
        
        app.staticTexts["Press and hold"].press(forDuration: 2.5)
        
        app.staticTexts["Hello world!"].assertElementExists(timeout: 2)
    }
    
    @MainActor
    func testHomeButtonAndLaunchSync() {
        let app = App()
        
        showView(GoToBackgroundAndBackView())
        
        Assert(app.staticTexts["WasInBackground: false"].exists)
        
        app.pressHomeButton()
        app.activate()
        
        app.staticTexts["WasInBackground: true"].assertElementExists()
    }
    
    @MainActor
    func testTwoFingerTapSync() {
        let app = App()
        
        showView(TapView())
        
        Assert(app.otherElements["TwoFingersView"].exists)
        
        app.otherElements["TwoFingersView"].twoFingerTap()
        
        app.staticTexts["Two fingers tapped"].assertElementExists()
    }
    
    @MainActor
    func testThreeFingerTapSync() {
        let app = App()
        
        showView(TapView())
        
        app.otherElements["ThreeFingersView"].assertElementExists().tap(withNumberOfTaps: 1, numberOfTouches: 3)
        
        app.staticTexts["Three fingers tapped"].assertElementExists()
    }
    
    @MainActor
    func testPinchSync() {
        let app = App()
        
        showView(PinchView())
        
        Assert(app.staticTexts["Did scale? No"].exists)
        
        app.staticTexts["PinchContainer"].pinch(withScale: 1.5, velocity: 1)
        
        app.staticTexts["Did scale? Yes"].assertElementExists()
    }
    
    @MainActor
    func testRotateSync() {
        let app = App()
        
        showView(RotateView())
        
        app.staticTexts["Did rotate? No"].assertElementExists()
        
        app.staticTexts["Rotate me!"].rotate(0.2, withVelocity: 1)
        
        app.staticTexts["Did rotate? Yes"].assertElementExists()
    }
    
    @MainActor
    func testMatchingWithPredicateAsync() {
        let app = App()
        
        showView(SomethingView())
        
        let somethingView = app.staticTexts.element(matching: NSPredicate(format: "label == %@", "SomethingViewAccessbilityLabel"))
        
        somethingView.assertElementExists()
    }
    
    @MainActor
    func testEnterTestOnWrongElementFails() {
        XCTExpectFailure("Expecting failure when attempting to type text into a non-text field element.")
        
        let app = App()
        
        showView(WaitForExistenceView())
        
        app.buttons["Show Message"].typeText("Hello world")
    }
    
    @available(iOS 17.0, *)
    @MainActor
    func testAccessibilityInspection() throws {
        XCTExpectFailure("Expecting failure when performing an accessibility audit")
        
        let app = App()
        
        showView(AccessibilityAuditView())
        
        try app.performAccessibilityAudit()
    }
}

// Two classes to run in parallel using two simulators
class ClientTests2: ClientTests { }
class ClientTests3: ClientTests { }
class ClientTests4: ClientTests { }

public func Assert(_ value: Bool, _ message: @Sendable @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    XCTAssert(value, message(), file: file, line: line)
}
