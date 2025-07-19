import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

/// A class responsible for handling coordinate-based routes
@MainActor
final class CoordinateRoutes {
    private let cache: ServerState
    private let routeRegistrar: RouteRegistering
    
    /// Initializes a new CoordinateRoutes instance
    /// - Parameters:
    ///   - cache: The server state cache for managing application instances
    ///   - routeRegistrar: The object responsible for registering routes
    init(cache: ServerState, routeRegistrar: RouteRegistering) {
        self.cache = cache
        self.routeRegistrar = routeRegistrar
    }
    
    /// Registers routes for coordinate-based operations
    /// - coordinate: Gets coordinate from element
    /// - coordinateWithOffset: Gets coordinate with offset
    /// - coordinateTap: Performs tap at coordinate
    func registerRoutes() async {
        await routeRegistrar.addRoute("coordinate", handler: coordinate(request:))
        await routeRegistrar.addRoute("coordinateWithOffset", handler: coordinateWithOffset(request:))
        await routeRegistrar.addRoute("coordinateTap", handler: coordinateTap(request:))
    }

    private func coordinate(request: CoordinateRequest) async throws -> CoordinateResponse {
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

    private func coordinateWithOffset(request: CoordinateOffsetRequest) async throws -> CoordinateResponse {
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

    private func coordinateTap(request: TapCoordinateRequest) async throws -> Bool {
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

// MARK: - UIServer + Coordinate Routes
extension UIServer {
    /// Registers routes for coordinate-based operations
    func registerCoordinateRoutes() async {
        let routes = CoordinateRoutes(cache: cache, routeRegistrar: self)
        await routes.registerRoutes()
    }
}
