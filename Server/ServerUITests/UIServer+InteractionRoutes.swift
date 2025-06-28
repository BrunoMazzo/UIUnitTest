import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Interaction Routes
extension UIServer {
    /// Registers routes for element interactions and gestures
    /// - tapElement: Performs tap gesture on element
    /// - doubleTap: Performs double tap gesture on element
    /// - typeText: Types text into element
    /// - scroll: Scrolls element by delta values
    /// - swipe: Performs swipe gesture on element
    /// - pinch: Performs pinch gesture on element
    /// - rotate: Performs rotation gesture on element
    /// - HomeButton: Presses device home button
    func registerInteractionRoutes() async {
        await addRoute("tapElement", handler: tapElement(tapRequest:))
        await addRoute("doubleTap", handler: doubleTap(tapRequest:))
        await addRoute("typeText", handler: typeText(request:))
        await addRoute("scroll", handler: scroll(request:))
        await addRoute("swipe", handler: swipe(request:))
        await addRoute("pinch", handler: pinch(request:))
        await addRoute("rotate", handler: rotate(request:))
        await addRoute("HomeButton", handler: { (_: HomeButtonRequest) in
            XCUIDevice.shared.press(.home)
        })
    }
}
