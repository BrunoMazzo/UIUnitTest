import UIUnitTestAPI

/// An extension of `UIServer` that provides tap-related interaction methods for UI elements.
///
/// This extension adds functionality to perform various types of taps on UI elements,
/// including standard taps, multi-touch taps, long presses, and double taps.
extension UIServer {
    /// Performs a tap action on a specified UI element with various customization options.
    ///
    /// This method allows for different types of taps based on the provided `TapElementRequest`:
    /// - Standard single tap
    /// - Tap with specific number of taps and touches
    /// - Two-finger tap
    /// - Press and hold for a specified duration
    ///
    /// - Parameters:
    ///   - tapRequest: A `TapElementRequest` containing details about the tap interaction
    /// - Returns: A boolean indicating whether the tap was successfully performed
    /// - Throws: An error if the element cannot be retrieved from the cache
    @MainActor
    func tapElement(tapRequest: TapElementRequest) async throws -> Bool {
        guard let element = try? cache.getElement(tapRequest.serverId) else {
            return false
        }

        if let duration = tapRequest.duration {
            element.press(forDuration: duration)
        } else if let numberOfTouches = tapRequest.numberOfTouches {
            if let numberOfTaps = tapRequest.numberOfTaps {
                element.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
            } else {
                element.twoFingerTap()
            }
        } else {
            element.tap()
        }

        return true
    }

    /// Performs a double tap on a specified UI element.
    ///
    /// - Parameters:
    ///   - tapRequest: An `ElementPayload` containing the server ID of the element to double tap
    /// - Throws: An error if the element cannot be retrieved from the cache
    @MainActor
    func doubleTap(tapRequest: ElementPayload) async throws {
        let element = try cache.getElement(tapRequest.serverId)
        element.doubleTap()
    }
}
