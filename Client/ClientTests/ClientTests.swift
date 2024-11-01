@testable import Client
import UIUnitTest
import XCTest

class ClientTests: XCTestCase, @unchecked Sendable {
    override func setUp() async throws {
        await UIView.setAnimationsEnabled(false)
    }

    func testExists() async throws {
        let app = try await App()

        showView(MySettingTable())

        try await app.staticTexts("Hello world button").assertElementExists2()

        try await Assert(app.staticTexts("Hello world button").isHittable())

        try await app.buttons("Hello world button").tap()

        try await app.staticTexts("Value: Hello world").assertElementExists()
    }

    func testEnterText() async throws {
        let app = try await App()

        showView(MySettingTable())

        try await app.buttons("TextField").assertElementExists().tap()

        try await app.textFields("TextField-Default").assertElementExists().tap()

        try await app.textFields("TextField-Default").typeText("Hello world")

        try await app.staticTexts("Text value: Hello world").assertElementExists()
    }

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

    func testWaitForExistence() async throws {
        let app = try await App()

        showView(WaitForExistenceView())

        try await app.staticTexts("Hello world!").assertElementDoesntExists()

        try await app.buttons("Show Message").tap()

        try await app.staticTexts("Hello world!").assertElementExists()
    }

    func testHomeButtonAndLaunch() async throws {
        let app = try await App()

        showView(GoToBackgroundAndBackView())

        try await app.staticTexts("WasInBackground: false").assertElementExists()

        try await app.pressHomeButton()
        try await app.activate()

        try await app.staticTexts("WasInBackground: true").assertElementExists()
    }

    func testPinch() async throws {
        let app = try await App()

        showView(PinchView())

        try await app.staticTexts("Did scale? No").assertElementExists()

        try await app.staticTexts("PinchContainer").assertElementExists().pinch(withScale: 1.5, velocity: 1)

        try await app.staticTexts("Did scale? Yes").assertElementExists()
    }

    func testRotate() async throws {
        let app = try await App()

        showView(RotateView())

        try await app.staticTexts("Did rotate? No").assertElementExists()

        try await app.staticTexts("Rotate me!").assertElementExists().rotate(0.2, withVelocity: 1)

        try await app.staticTexts("Did rotate? Yes").assertElementExists()
    }

    func testMatchingWithPredicate() async throws {
        let app = try await App()

        showView(SomethingView())

        try await app.staticTexts().element(matching: NSPredicate(format: "label == %@", "SomethingViewAccessbilityLabel")).assertElementExists()
    }

    func testExistsSync() {
        let app = App()

        showView(MySettingTable())

        app.buttons["Hello world button"].assertElementExists().tap()

        app.staticTexts["Value: Hello world"].assertElementExists()
    }

    func testEnterTextSync() {
        let app = App()

        showView(MySettingTable())

        app.buttons["TextField"].assertElementExists().tap()

        app.textFields["TextField-Default"].assertElementExists().tap()

        app.textFields["TextField-Default"].typeText("Hello world")

        app.staticTexts["Text value: Hello world"].assertElementExists()
    }

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

    func testWaitForExistenceSync() {
        let app = App()

        showView(WaitForExistenceView())

        app.staticTexts["Hello world!"].assertElementDoesntExists()

        app.buttons["Show Message"].assertElementExists().tap()

        app.staticTexts["Hello world!"].assertElementExists(timeout: 2)
    }

    func testHomeButtonAndLaunchSync() {
        let app = App()

        showView(GoToBackgroundAndBackView())

        app.staticTexts["WasInBackground: false"].assertElementExists()

        app.pressHomeButton()
        app.activate()

        app.staticTexts["WasInBackground: true"].assertElementExists()
    }

    func testPinchSync() {
        let app = App()

        showView(PinchView())

        app.staticTexts["Did scale? No"].assertElementExists()

        app.staticTexts["PinchContainer"]
            .assertElementExists()
            .pinch(withScale: 1.5, velocity: 1)

        app.staticTexts["Did scale? Yes"].assertElementExists()
    }

    func testRotateSync() {
        let app = App()

        showView(RotateView())

        app.staticTexts["Did rotate? No"].assertElementExists()

        app.staticTexts["Rotate me!"]
            .assertElementExists()
            .rotate(0.2, withVelocity: 1)

        app.staticTexts["Did rotate? Yes"].assertElementExists()
    }

    func testMatchingWithPredicateAsync() {
        let app = App()

        showView(SomethingView())

        let somethingView = app.staticTexts.element(matching: NSPredicate(format: "label == %@", "SomethingViewAccessbilityLabel"))

        somethingView.assertElementExists()
    }

    func testEnterTestOnWrongElementFails() {
        XCTExpectFailure("Expecting failure when attempting to type text into a non-text field element.")

        let app = App()

        showView(WaitForExistenceView())

        app.buttons["Show Message"].typeText("Hello world")
    }

    @available(iOS 17.0, *)
    func testAccessibilityInspection() throws {
        XCTExpectFailure("Expecting failure when performing an accessibility audit")

        let app = App()

        showView(AccessibilityAuditView())

        try app.performAccessibilityAudit()
    }
}

public func Assert(_ value: Bool, _ message: @Sendable @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    XCTAssert(value, message(), file: file, line: line)
}

extension Element {
    @discardableResult
    func assertElementExists2(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) -> Element {
        Executor.execute {
            try await self.assertElementExists(message: message, timeout: timeout, fileID: fileID, filePath: filePath, line: line, column: column)
        }.valueOrFailWithFallback(self)
    }
}

extension Result {
    func valueOrFailWithFallback(
        _ fallback: Success,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) -> Success {
        switch self {
        case let .success(result):
            return result
        case let .failure(error):
            XCTFail(error.localizedDescription)
            return fallback
        }
    }
}

