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

    @MainActor
    func coordinate(request: CoordinateRequest) async throws -> CoordinateResponse {
        // withNormalizedOffset: CGVector
        let rootElement = try cache.getElement(request.serverId)
        let coordinate = rootElement.coordinate(withNormalizedOffset: request.normalizedOffset)

        let coordinateUUID = cache.add(coordinate: coordinate)
        let elementUUID = cache.add(element: coordinate.referencedElement)

        return CoordinateResponse(
            coordinateId: coordinateUUID,
            referencedElementId: elementUUID,
            screenPoint: coordinate.screenPoint
        )
    }

    @MainActor
    func coordinateWithOffset(request: CoordinateOffsetRequest) async throws -> CoordinateResponse {
        let rootCoordinate = try cache.getCoordinate(request.coordinatorId)
        let coordinate = rootCoordinate.withOffset(request.vector)

        let coordinateUUID = cache.add(coordinate: coordinate)
        let elementUUID = cache.add(element: coordinate.referencedElement)

        return CoordinateResponse(
            coordinateId: coordinateUUID,
            referencedElementId: elementUUID,
            screenPoint: coordinate.screenPoint
        )
    }

    @MainActor
    func coordinateTap(request: TapCoordinateRequest) async throws -> Bool {
        let rootCoordinate = try cache.getCoordinate(request.serverId)

        switch request.type {
        case .tap:
            rootCoordinate.tap()
        case .doubleTap:
            rootCoordinate.doubleTap()
        case let .press(forDuration: duration):
            rootCoordinate.press(forDuration: duration)
        case let .pressAndDrag(forDuration: duration, thenDragTo: coordinate):
            let coordinate = try cache.getCoordinate(coordinate)
            rootCoordinate.press(forDuration: duration, thenDragTo: coordinate)
        case let .pressDragAndHold(
            forDuration: duration,
            thenDragTo: coordinate,
            withVelocity: velocity,
            thenHoldForDuration: holdDuration
        ):
            let coordinate = try cache.getCoordinate(coordinate)
            rootCoordinate.press(
                forDuration: duration,
                thenDragTo: coordinate,
                withVelocity: velocity.xcUIGestureVelocity,
                thenHoldForDuration: holdDuration
            )
        }

        return true
    }
}
