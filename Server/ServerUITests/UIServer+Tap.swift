import UIUnitTestAPI

extension UIServer {
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

    @MainActor
    func doubleTap(tapRequest: ElementPayload) async throws {
        let element = try cache.getElement(tapRequest.serverId)
        element.doubleTap()
    }
}
