import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Coordinate Routes
extension UIServer {
    /// Registers routes for coordinate-based operations
    /// - coordinate: Gets coordinate from element
    /// - coordinateWithOffset: Gets coordinate with offset
    /// - coordinateTap: Performs tap at coordinate
    func registerCoordinateRoutes() async {
        await addRoute("coordinate", handler: coordinate(request:))
        await addRoute("coordinateWithOffset", handler: coordinateWithOffset(request:))
        await addRoute("coordinateTap", handler: coordinateTap(request:))
    }
}
