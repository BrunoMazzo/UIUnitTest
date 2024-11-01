@testable import Client
import UIUnitTest
import XCTest

class TapTests: XCTestCase {

    func testTap() async throws {
        let app = try await App()

        showView(MySettingTable())

        let somethingButton = try await app.buttons("Something")
        try await Assert(somethingButton.isHittable())

        try await somethingButton.tap()

        try await app.staticTexts("Something View").assertElementExists()
    }

    func testTapSync() {
        let app = App()

        showView(MySettingTable())

        let somethingButton = app.buttons["Something"]
        Assert(somethingButton.isHittable)

        somethingButton.tap()

        app.staticTexts["Something View"].assertElementExists(timeout: 2)
    }

    func testDoubleTap() async throws {
        let app = try await App()

        showView(MySettingTable())

        try await app.staticTexts("Double tap").assertElementExists().doubleTap()

        try await app.staticTexts("Value: Double tap").assertElementExists()
    }

    func testDoubleTapSync() {
        let app = App()

        showView(MySettingTable())

        app.staticTexts["Double tap"].assertElementExists().doubleTap()

        app.staticTexts["Value: Double tap"].assertElementExists()
    }

    func testPressWithDuration() async throws {
        let app = try await App()

        showView(PressAndHoldView())

        try await app.staticTexts("Hello world!").assertElementDoesntExists()

        try await app.staticTexts("Press and hold").assertElementExists().press(forDuration: 2.5)

        try await app.staticTexts("Hello world!").assertElementExists()
    }

    func testPressWithDurationSync() {
        let app = App()

        showView(PressAndHoldView())

        app.staticTexts["Hello world!"].assertElementDoesntExists()

        app.staticTexts["Press and hold"].press(forDuration: 2.5)

        app.staticTexts["Hello world!"].assertElementExists(timeout: 2)
    }

    func testTwoFingerTap() async throws {
        let app = try await App()

        showView(TapView())

        try await app.otherElements("TwoFingersView").assertElementExists().twoFingerTap()

        try await app.staticTexts("Two fingers tapped").assertElementExists()
    }

    func testTwoFingerTapSync() {
        let app = App()

        showView(TapView())

        app.otherElements["TwoFingersView"]
            .assertElementExists()
            .twoFingerTap()

        app.staticTexts["Two fingers tapped"].assertElementExists()
    }

    func testThreeFingerTap() async throws {
        let app = try await App()

        showView(TapView())

        try await app.otherElements("ThreeFingersView").assertElementExists().tap(withNumberOfTaps: 1, numberOfTouches: 3)

        try await app.staticTexts("Three fingers tapped").assertElementExists()
    }

    func testThreeFingerTapSync() {
        let app = App()

        showView(TapView())

        app.otherElements["ThreeFingersView"].assertElementExists().tap(withNumberOfTaps: 1, numberOfTouches: 3)

        app.staticTexts["Three fingers tapped"].assertElementExists()
    }
}
