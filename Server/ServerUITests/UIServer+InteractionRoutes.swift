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

    /// Performs a tap gesture on an element
    ///
    /// This method executes a single tap on a specific UI element. The tap can be
    /// configured with various parameters like duration and number of taps.
    ///
    /// - Parameters:
    ///   - tapRequest: Contains the server ID of the element and tap configuration
    /// - Returns: A boolean indicating whether the tap was successful
    /// - Throws: Errors related to element retrieval or tap execution
    @MainActor
    func tapElement(tapRequest: TapRequest) async throws -> Bool {
        let element = try cache.getElement(tapRequest.serverId)

        switch tapRequest.type {
        case .tap:
            element.tap()
        case .doubleTap:
            element.doubleTap()
        case let .press(forDuration: duration):
            element.press(forDuration: duration)
        case let .pressAndDrag(forDuration: duration, thenDragTo: coordinate):
            let coordinate = try cache.getCoordinate(coordinate)
            element.press(forDuration: duration, thenDragTo: coordinate)
        case let .pressDragAndHold(
            forDuration: duration,
            thenDragTo: coordinate,
            withVelocity: velocity,
            thenHoldForDuration: holdDuration
        ):
            let coordinate = try cache.getCoordinate(coordinate)
            element.press(
                forDuration: duration,
                thenDragTo: coordinate,
                withVelocity: velocity.xcUIGestureVelocity,
                thenHoldForDuration: holdDuration
            )
        }

        return true
    }

    /// Performs a double tap gesture on an element
    ///
    /// This method executes a double tap on a specific UI element. It's a convenience
    /// method that's equivalent to a tap with a count of 2.
    ///
    /// - Parameters:
    ///   - tapRequest: Contains the server ID of the element to double tap
    /// - Returns: A boolean indicating whether the double tap was successful
    /// - Throws: Errors related to element retrieval or tap execution
    @MainActor
    func doubleTap(tapRequest: TapRequest) async throws -> Bool {
        let element = try cache.getElement(tapRequest.serverId)
        element.doubleTap()
        return true
    }

    /// Types text into an element
    ///
    /// This method simulates keyboard input to enter text into a text field or
    /// other text input element.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element and the text to type
    /// - Returns: A boolean indicating whether the text input was successful
    /// - Throws: Errors related to element retrieval or text input
    @MainActor
    func typeText(request: TypeTextRequest) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        element.typeText(request.text)
        return true
    }

    /// Scrolls an element by specified delta values
    ///
    /// This method performs a scroll gesture on an element, moving it by the
    /// specified amounts in the horizontal and vertical directions.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element and scroll deltas
    /// - Returns: A boolean indicating whether the scroll was successful
    /// - Throws: Errors related to element retrieval or scroll execution
    @MainActor
    func scroll(request: ScrollRequest) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        element.scroll(byDeltaX: request.deltaX, deltaY: request.deltaY)
        return true
    }

    /// Performs a swipe gesture on an element
    ///
    /// This method executes a swipe gesture in the specified direction on a UI element.
    /// The swipe can be configured with a specific velocity.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element and swipe configuration
    /// - Returns: A boolean indicating whether the swipe was successful
    /// - Throws: Errors related to element retrieval or swipe execution
    @MainActor
    func swipe(request: SwipeRequest) async throws -> Bool {
        let element = try cache.getElement(request.serverId)

        switch request.direction {
        case .up:
            element.swipeUp()
        case .down:
            element.swipeDown()
        case .left:
            element.swipeLeft()
        case .right:
            element.swipeRight()
        }

        return true
    }

    /// Performs a pinch gesture on an element
    ///
    /// This method executes a pinch gesture on a UI element, which can be either
    /// a pinch-in (zoom out) or pinch-out (zoom in) gesture.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element and pinch configuration
    /// - Returns: A boolean indicating whether the pinch was successful
    /// - Throws: Errors related to element retrieval or pinch execution
    @MainActor
    func pinch(request: PinchRequest) async throws -> Bool {
        let element = try cache.getElement(request.serverId)

        switch request.direction {
        case .inward:
            element.pinch(withScale: request.scale, velocity: request.velocity)
        case .outward:
            element.pinch(withScale: request.scale, velocity: -request.velocity)
        }

        return true
    }

    /// Performs a rotation gesture on an element
    ///
    /// This method executes a rotation gesture on a UI element, rotating it by
    /// the specified angle with a given velocity.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element and rotation configuration
    /// - Returns: A boolean indicating whether the rotation was successful
    /// - Throws: Errors related to element retrieval or rotation execution
    @MainActor
    func rotate(request: RotateRequest) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        element.rotate(request.rotation, withVelocity: request.velocity)
        return true
    }
}
