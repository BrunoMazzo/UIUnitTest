import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

/// A class responsible for handling element state routes
@MainActor
final class ElementStateRoutes {
    private let cache: ServerState
    private let routeRegistrar: RouteRegistering
    
    /// Initializes a new ElementStateRoutes instance
    /// - Parameters:
    ///   - cache: The server state cache for managing application instances
    ///   - routeRegistrar: The object responsible for registering routes
    init(cache: ServerState, routeRegistrar: RouteRegistering) {
        self.cache = cache
        self.routeRegistrar = routeRegistrar
    }
    
    /// Registers routes for element state checking
    /// - exists: Checks if element exists
    /// - waitForExistence: Waits for element to exist
    /// - waitForNonExistence: Waits for element to not exist
    /// - value: Gets element value
    /// - isHittable: Checks if element is hittable
    func registerRoutes() async {
        await routeRegistrar.addRoute("exists", handler: exists(request:))
        await routeRegistrar.addRoute("waitForExistence", handler: waitForExistence(request:))
        await routeRegistrar.addRoute("waitForNonExistence", handler: waitForNonExistence(request:))
        await routeRegistrar.addRoute("value", handler: value(request:))
        await routeRegistrar.addRoute("isHittable", handler: isHittable(request:))
    }

    /// Checks if an element exists in the UI hierarchy
    ///
    /// This method determines whether a specific UI element is currently present
    /// in the interface. It's useful for verifying element visibility or availability.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element to check
    /// - Returns: A boolean indicating whether the element exists
    /// - Throws: Errors related to element retrieval
    private func exists(request: ElementPayload) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        return element.exists
    }

    /// Waits for an element to exist in the UI hierarchy
    ///
    /// This method waits for a specified duration for an element to become present
    /// in the interface. It's useful for handling dynamic UI changes.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element and timeout duration
    /// - Returns: A boolean indicating whether the element appeared within the timeout
    /// - Throws: Errors related to element retrieval
    private func waitForExistence(request: WaitForExistenceRequest) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        return element.waitForExistence(timeout: request.timeout)
    }

    /// Waits for an element to disappear from the UI hierarchy
    ///
    /// This method waits for a specified duration for an element to become absent
    /// from the interface. It's useful for handling dynamic UI changes.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element and timeout duration
    /// - Returns: A boolean indicating whether the element disappeared within the timeout
    /// - Throws: Errors related to element retrieval
    private func waitForNonExistence(request: WaitForExistenceRequest) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        return element.waitForNonExistence(timeout: request.timeout)
    }

    /// Retrieves the value of an element
    ///
    /// This method returns the current value of a UI element. The interpretation
    /// of "value" depends on the element type (e.g., text for text fields,
    /// selection for pickers).
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A `ValueResponse` containing the element's value
    /// - Throws: Errors related to element retrieval
    private func value(request: ElementPayload) async throws -> ValueResponse {
        let element = try cache.getElement(request.serverId)
        return ValueResponse(value: element.value as? String ?? "")
    }

    /// Checks if an element is hittable
    ///
    /// This method determines whether a specific UI element can be interacted with
    /// through taps or clicks. An element is hittable if it's visible and not
    /// obscured by other elements.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A boolean indicating whether the element is hittable
    /// - Throws: Errors related to element retrieval
    private func isHittable(request: ElementPayload) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        return element.isHittable
    }
}

// MARK: - UIServer + Element State Routes
extension UIServer {
    /// Registers routes for element state checking
    func registerElementStateRoutes() async {
        let routes = ElementStateRoutes(cache: cache, routeRegistrar: self)
        await routes.registerRoutes()
    }
}
