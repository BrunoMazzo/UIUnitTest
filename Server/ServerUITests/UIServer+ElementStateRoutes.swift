import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Element State Routes
extension UIServer {
    /// Registers routes for element state checking
    /// - exists: Checks if element exists
    /// - waitForExistence: Waits for element to exist
    /// - waitForNonExistence: Waits for element to not exist
    /// - value: Gets element value
    /// - isHittable: Checks if element is hittable
    func registerElementStateRoutes() async {
        await addRoute("exists", handler: exists(request:))
        await addRoute("waitForExistence", handler: waitForExistence(request:))
        await addRoute("waitForNonExistence", handler: waitForNonExistence(request:))
        await addRoute("value", handler: value(request:))
        await addRoute("isHittable", handler: isHittable(request:))
    }
}
