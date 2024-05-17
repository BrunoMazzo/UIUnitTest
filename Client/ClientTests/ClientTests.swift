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
        
        try await app.staticTexts("Something View").assertElementExists()
    }
    
    @MainActor
    func testExists() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.staticTexts("Hello world button").assertElementExists()
        
        try await Assert(app.staticTexts("Hello world button").isHittable())
        
        try await app.buttons("Hello world button").tap()

        try await app.staticTexts("Value: Hello world").assertElementExists()
    }
    
    @MainActor
    func testDoubleTap() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.staticTexts("Double tap").assertElementExists().doubleTap()
        
        try await app.staticTexts("Value: Double tap").assertElementExists()
    }
    
    @MainActor
    func testEnterText() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.buttons("TextField").assertElementExists().tap()
        
        try await app.textFields("TextField-Default").assertElementExists().tap()
        
        try await app.textFields("TextField-Default").typeText("Hello world")
        
        try await app.staticTexts("Text value: Hello world").assertElementExists()
    }
    
    @MainActor
    func testSwipeActions() async throws {
        let app = try await App()
        
        showView(SwipeView())
        
        try await app.staticTexts("Direction: No swipe detected").assertElementExists()
        
        try await app.staticTexts("Swipe me").swipeUp()
        try await app.staticTexts("Direction: Up").assertElementExists()
        
        try await app.staticTexts("Swipe me").swipeDown()
        try await app.staticTexts("Direction: Down").assertElementExists()
        
        try await app.staticTexts("Swipe me").swipeLeft()
        try await app.staticTexts("Direction: Left").assertElementExists()
        
        try await app.staticTexts("Swipe me").swipeRight()
        try await app.staticTexts("Direction: Right").assertElementExists()
        
        try await app.staticTexts("Swipe me").swipeUp(velocity: 100)
        try await app.staticTexts("Direction: Up").assertElementExists()
        
        try await app.staticTexts("Swipe me").swipeDown(velocity: 100.5)
        try await app.staticTexts("Direction: Down").assertElementExists()
        
        let velocityCGFloat: CGFloat = 500
        try await app.staticTexts("Swipe me").swipeLeft(velocity: GestureVelocity(velocityCGFloat))
        try await app.staticTexts("Direction: Left").assertElementExists()
        
        try await app.staticTexts("Swipe me").swipeRight(velocity: 600)
        try await app.staticTexts("Direction: Right").assertElementExists()
    }
    
    @MainActor
    func testWaitForExistence() async throws {
        let app = try await App()
        
        showView(WaitForExistenceView())
        
        try await Assert(app.staticTexts("Hello world!").exists() == false)
        
        try await app.buttons("Show Message").tap()
        
        try await app.staticTexts("Hello world!").assertElementExists()
    }
    
    @MainActor
    func testPressWithDuration() async throws {
        let app = try await App()
        
        showView(PressAndHoldView())
        
        try await Assert(app.staticTexts("Hello world!").exists() == false)
        
        try await app.staticTexts("Press and hold").assertElementExists().press(forDuration: 2.5)
        
        try await app.staticTexts("Hello world!").assertElementExists()
    }

    @MainActor
    func testHomeButtonAndLaunch() async throws {
        let app = try await App()
        
        showView(GoToBackgroundAndBackView())
        
        try await app.staticTexts("WasInBackground: false").assertElementExists()
        
        try await app.pressHomeButton()
        try await app.activate()
        
        try await app.staticTexts("WasInBackground: true").assertElementExists()
    }
    
    @MainActor
    func testTwoFingerTap() async throws {
        let app = try await App()
        
        showView(TapView())
        
        try await app.otherElements("TwoFingersView").assertElementExists().twoFingerTap()
        
        try await app.staticTexts("Two fingers tapped").assertElementExists()
    }
    
    @MainActor
    func testThreeFingerTap() async throws {
        let app = try await App()
        
        showView(TapView())
        
        try await app.otherElements("ThreeFingersView").assertElementExists().tap(withNumberOfTaps: 1, numberOfTouches: 3)
        
        try await app.staticTexts("Three fingers tapped").assertElementExists()
    }
    
    @MainActor
    func testPinch() async throws {
        let app = try await App()
        
        showView(PinchView())
        
        try await app.staticTexts("Did scale? No").assertElementExists()
        
        try await app.staticTexts("PinchContainer").assertElementExists().pinch(withScale: 1.5, velocity: 1)
        
        try await app.staticTexts("Did scale? Yes").assertElementExists()
    }
    
    @MainActor
    func testRotate() async throws {
        let app = try await App()
        
        showView(RotateView())
        
        try await app.staticTexts("Did rotate? No").assertElementExists()
        
        try await app.staticTexts("Rotate me!").assertElementExists().rotate(0.2, withVelocity: 1)
        
        try await app.staticTexts("Did rotate? Yes").assertElementExists()
    }
    
    @MainActor
    func testMatchingWithPredicate() async throws {
        let app = try await App()
        
        showView(SomethingView())
        
        try await app.staticTexts().element(matching: NSPredicate(format: "label == %@", "SomethingViewAccessbilityLabel")).assertElementExists()
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
        
        app.buttons["Hello world button"].assertElementExists().tap()
        
        app.staticTexts["Value: Hello world"].assertElementExists()
    }
    
    @MainActor
    func testDoubleTapSync() {
        let app = App()
        
        showView(MySettingTable())
        
        app.staticTexts["Double tap"].assertElementExists().doubleTap()
        
        app.staticTexts["Value: Double tap"].assertElementExists()
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
        
        app.staticTexts["WasInBackground: false"].assertElementExists()
        
        app.pressHomeButton()
        app.activate()
        
        app.staticTexts["WasInBackground: true"].assertElementExists()
    }
    
    @MainActor
    func testTwoFingerTapSync() {
        let app = App()
        
        showView(TapView())
        
        app.otherElements["TwoFingersView"]
            .assertElementExists()
            .twoFingerTap()
        
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
        
        app.staticTexts["Did scale? No"].assertElementExists()
        
        app.staticTexts["PinchContainer"]
            .assertElementExists()
            .pinch(withScale: 1.5, velocity: 1)
        
        app.staticTexts["Did scale? Yes"].assertElementExists()
    }
    
    @MainActor
    func testRotateSync() {
        let app = App()
        
        showView(RotateView())
        
        app.staticTexts["Did rotate? No"].assertElementExists()
        
        app.staticTexts["Rotate me!"]
            .assertElementExists()
            .rotate(0.2, withVelocity: 1)
        
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
