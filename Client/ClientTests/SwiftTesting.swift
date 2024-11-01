import Testing
import UIUnitTest
import UIKit
@testable import Client

@Suite(.uiTest)
final class SwiftTesting {
    
    @Test
    func testTap() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        let somethingButton = try await app.buttons("Something")
        
        #expect(try await somethingButton.isHittable())
        
        try await somethingButton.tap()
        
        try await app.staticTexts("Something View").assertElementExists()
    }
    
    @Test
    func testExists() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.staticTexts("Hello world button").assertElementExists()
        
        #expect(try await app.staticTexts("Hello world button").isHittable())
        
        try await app.buttons("Hello world button").tap()
        
        try await app.staticTexts("Value: Hello world").assertElementExists()
    }
    
    @Test
    func testDoubleTap() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.staticTexts("Double tap").assertElementExists().doubleTap()
        
        try await app.staticTexts("Value: Double tap").assertElementExists()
    }
    
    @Test
    func testEnterText() async throws {
        let app = try await App()
        
        showView(MySettingTable())
        
        try await app.buttons("TextField").assertElementExists().tap()
        
        try await app.textFields("TextField-Default").assertElementExists().tap()
        
        try await app.textFields("TextField-Default").typeText("Hello world")
        
        try await app.staticTexts("Text value: Hello world").assertElementExists()
    }
    
    @Test
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
    
    @Test
    func testWaitForExistence() async throws {
        let app = try await App()
        
        showView(WaitForExistenceView())
        
        try await app.staticTexts("Hello world!").assertElementDoesntExists()
        
        try await app.buttons("Show Message").tap()
        
        try await app.staticTexts("Hello world!").assertElementExists()
    }
    
    @Test
    func testPressWithDuration() async throws {
        let app = try await App()
        
        showView(PressAndHoldView())
        
        try await app.staticTexts("Hello world!").assertElementDoesntExists()
        
        try await app.staticTexts("Press and hold").assertElementExists().press(forDuration: 2.5)
        
        try await app.staticTexts("Hello world!").assertElementExists()
    }
    
    @Test
    func testHomeButtonAndLaunch() async throws {
        let app = try await App()
        
        showView(GoToBackgroundAndBackView())
        
        try await app.staticTexts("WasInBackground: false").assertElementExists()
        
        try await app.pressHomeButton()
        try await app.activate()
        
        try await app.staticTexts("WasInBackground: true").assertElementExists()
    }
    
    @Test
    func testTwoFingerTap() async throws {
        let app = try await App()
        
        showView(TapView())
        
        try await app.otherElements("TwoFingersView").assertElementExists().twoFingerTap()
        
        try await app.staticTexts("Two fingers tapped").assertElementExists()
    }
    
    @Test
    func testThreeFingerTap() async throws {
        let app = try await App()
        
        showView(TapView())
        
        try await app.otherElements("ThreeFingersView").assertElementExists().tap(withNumberOfTaps: 1, numberOfTouches: 3)
        
        try await app.staticTexts("Three fingers tapped").assertElementExists()
    }
    
    @Test
    func testPinch() async throws {
        let app = try await App()
        
        showView(PinchView())
        
        try await app.staticTexts("Did scale? No").assertElementExists()
        
        try await app.staticTexts("PinchContainer").assertElementExists().pinch(withScale: 1.5, velocity: 1)
        
        try await app.staticTexts("Did scale? Yes").assertElementExists()
    }
    
    @Test
    func testRotate() async throws {
        let app = try await App()
        
        showView(RotateView())
        
        try await app.staticTexts("Did rotate? No").assertElementExists()
        
        try await app.staticTexts("Rotate me!").assertElementExists().rotate(0.2, withVelocity: 1)
        
        try await app.staticTexts("Did rotate? Yes").assertElementExists()
    }
    
    @Test
    func testMatchingWithPredicate() async throws {
        let app = try await App()
        
        showView(SomethingView())
        
        try await app.staticTexts().element(matching: NSPredicate(format: "label == %@", "SomethingViewAccessbilityLabel")).assertElementExists()
    }
    
    @Test
    func testTapSync() {
        let app = App()
        
        showView(MySettingTable())
        
        let somethingButton = app.buttons["Something"]
        Assert(somethingButton.isHittable)
        
        somethingButton.tap()
        
        app.staticTexts["Something View"].assertElementExists(timeout: 2)
    }
    
    @Test
    func testExistsSync() {
        let app = App()
        
        showView(MySettingTable())
        
        app.buttons["Hello world button"].assertElementExists().tap()
        
        app.staticTexts["Value: Hello world"].assertElementExists()
    }
    
    @Test
    func testDoubleTapSync() {
        let app = App()
        
        showView(MySettingTable())
        
        app.staticTexts["Double tap"].assertElementExists().doubleTap()
        
        app.staticTexts["Value: Double tap"].assertElementExists()
    }
    
    @Test
    func testEnterTextSync() {
        let app = App()
        
        showView(MySettingTable())
        
        app.buttons["TextField"].assertElementExists().tap()
        
        app.textFields["TextField-Default"].assertElementExists().tap()
        
        app.textFields["TextField-Default"].typeText("Hello world")
        
        app.staticTexts["Text value: Hello world"].assertElementExists()
    }
    
    @Test
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
    
// Failing because it is blocking the main thread.
// No idea why it works if we test using XCTest. Ideally, I think I will deprecate the sync API
    @Test
    func testWaitForExistenceSync() {
        let app = App()
        
        showView(WaitForExistenceView())
        
        app.staticTexts["Hello world!"].assertElementDoesntExists()
        
        app.buttons["Show Message"].assertElementExists().tap()
        
        app.staticTexts["Hello world!"].assertElementExists(timeout: 3)
    }
    
    @Test
    func testPressWithDurationSync() {
        let app = App()
        
        showView(PressAndHoldView())
        
        app.staticTexts["Hello world!"].assertElementDoesntExists()
        
        app.staticTexts["Press and hold"].press(forDuration: 2.5)
        
        app.staticTexts["Hello world!"].assertElementExists(timeout: 2)
    }
    
    @Test
    func testHomeButtonAndLaunchSync() {
        let app = App()
        
        showView(GoToBackgroundAndBackView())
        
        app.staticTexts["WasInBackground: false"].assertElementExists()
        
        app.pressHomeButton()
        app.activate()
        
        app.staticTexts["WasInBackground: true"].assertElementExists()
    }
    
    @Test
    func testTwoFingerTapSync() {
        let app = App()
        
        showView(TapView())
        
        app.otherElements["TwoFingersView"]
            .assertElementExists()
            .twoFingerTap()
        
        app.staticTexts["Two fingers tapped"].assertElementExists()
    }
    
    @Test
    func testThreeFingerTapSync() {
        let app = App()
        
        showView(TapView())
        
        app.otherElements["ThreeFingersView"].assertElementExists().tap(withNumberOfTaps: 1, numberOfTouches: 3)
        
        app.staticTexts["Three fingers tapped"].assertElementExists()
    }
    
    @Test
    func testPinchSync() {
        let app = App()
        
        showView(PinchView())
        
        app.staticTexts["Did scale? No"].assertElementExists()
        
        app.staticTexts["PinchContainer"]
            .assertElementExists()
            .pinch(withScale: 1.5, velocity: 1)
        
        app.staticTexts["Did scale? Yes"].assertElementExists()
    }
    
    @Test
    func testRotateSync() {
        let app = App()
        
        showView(RotateView())
        
        app.staticTexts["Did rotate? No"].assertElementExists()
        
        app.staticTexts["Rotate me!"]
            .assertElementExists()
            .rotate(0.2, withVelocity: 1)
        
        app.staticTexts["Did rotate? Yes"].assertElementExists()
    }
    
    @Test
    func testMatchingWithPredicateAsync() {
        let app = App()
        
        showView(SomethingView())
        
        let somethingView = app.staticTexts.element(matching: NSPredicate(format: "label == %@", "SomethingViewAccessbilityLabel"))
        
        somethingView.assertElementExists()
    }
    
    @Test
    func testEnterTestOnWrongElementFails() {
        withKnownIssue {
            let app = App()
            
            showView(WaitForExistenceView())
            
            app.buttons["Show Message"].typeText("Hello world")
        }
    }
    
    @available(iOS 17.0, *)
    @Test
    func testAccessibilityInspection() throws {
        withKnownIssue {
            let app = App()
            
            showView(AccessibilityAuditView())
            
            try app.performAccessibilityAudit()
        }
    }
}

// MARK: -
extension Trait where Self == ParallelizationTrait {
    /// A trait that serializes the test to which it is applied.
    ///
    /// ## See Also
    ///
    /// - ``ParallelizationTrait``
    public static var uiTest: Self {
        .serialized
    }
}
