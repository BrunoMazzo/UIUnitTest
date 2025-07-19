import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

/// A class responsible for handling element information routes
@MainActor
final class ElementInfoRoutes {
    private let cache: ServerState
    private let routeRegistrar: RouteRegistering
    
    /// Initializes a new ElementInfoRoutes instance
    /// - Parameters:
    ///   - cache: The server state cache for managing application instances
    ///   - routeRegistrar: The object responsible for registering routes
    init(cache: ServerState, routeRegistrar: RouteRegistering) {
        self.cache = cache
        self.routeRegistrar = routeRegistrar
    }
    
    /// Registers routes for element information retrieval
    /// - identifier: Gets element identifier
    /// - title: Gets element title
    /// - label: Gets element label
    /// - placeholderValue: Gets element placeholder value
    /// - isSelected: Checks if element is selected
    /// - hasFocus: Checks if element has focus
    /// - isEnabled: Checks if element is enabled
    /// - elementType: Gets element type
    /// - frame: Gets element frame
    /// - horizontalSizeClass: Gets horizontal size class
    /// - verticalSizeClass: Gets vertical size class
    func registerRoutes() async {
        await routeRegistrar.addRoute("identifier", handler: identifier(request:))
        await routeRegistrar.addRoute("title", handler: title(request:))
        await routeRegistrar.addRoute("label", handler: label(request:))
        await routeRegistrar.addRoute("placeholderValue", handler: placeholderValue(request:))
        await routeRegistrar.addRoute("isSelected", handler: isSelected(request:))
        await routeRegistrar.addRoute("hasFocus", handler: hasFocus(request:))
        await routeRegistrar.addRoute("isEnabled", handler: isEnabled(request:))
        await routeRegistrar.addRoute("elementType", handler: elementType(request:))
        await routeRegistrar.addRoute("frame", handler: frame(request:))
        await routeRegistrar.addRoute("horizontalSizeClass", handler: horizontalSizeClass(request:))
        await routeRegistrar.addRoute("verticalSizeClass", handler: verticalSizeClass(request:))
    }
    
    private func identifier(request: ElementPayload) async throws -> String {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.identifier
    }
    
    private func title(request: ElementPayload) async throws -> String {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.title
    }
    
    private func label(request: ElementPayload) async throws -> String {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.label
    }
    
    private func placeholderValue(request: ElementPayload) async throws -> String? {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.placeholderValue
    }

    /// Checks if an element is selected
    ///
    /// This method determines whether a specific UI element is currently in a selected state.
    /// This is commonly used for elements like checkboxes, radio buttons, or list items.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A boolean indicating whether the element is selected
    /// - Throws: Errors related to element retrieval
    private func isSelected(request: ElementPayload) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        return element.isSelected
    }

    /// Checks if an element has focus
    ///
    /// This method determines whether a specific UI element currently has input focus.
    /// Focus indicates which element is currently selected to receive input.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A boolean indicating whether the element has focus
    /// - Throws: Errors related to element retrieval
    private func hasFocus(request: ElementPayload) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        return element.hasFocus
    }

    /// Checks if an element is enabled
    ///
    /// This method determines whether a specific UI element is currently enabled for interaction.
    /// Disabled elements typically cannot receive user input or trigger actions.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A boolean indicating whether the element is enabled
    /// - Throws: Errors related to element retrieval
    private func isEnabled(request: ElementPayload) async throws -> Bool {
        let element = try cache.getElement(request.serverId)
        return element.isEnabled
    }

    /// Retrieves the element type of a UI element
    ///
    /// This method returns the type of a specific UI element, which indicates its role
    /// in the interface (e.g., button, text field, etc.).
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: An `ElementTypeResponse` containing the element's type
    /// - Throws: Errors related to element retrieval
    private func elementType(request: ElementPayload) async throws -> UInt {
        let element = try cache.getElement(request.serverId)
        return element.elementType.rawValue
    }

    /// Retrieves the frame of an element
    ///
    /// This method returns the frame (position and size) of a specific UI element
    /// in the coordinate system of its container.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A `FrameResponse` containing the element's frame coordinates
    /// - Throws: Errors related to element retrieval
    private func frame(request: ElementPayload) async throws -> CGRect {
        let element = try cache.getElement(request.serverId)
        return element.frame
    }

    /// Retrieves the horizontal size class of an element
    ///
    /// This method returns the horizontal size class of a specific UI element,
    /// which indicates how the element should be laid out horizontally.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A `UserInterfaceSizeClassResponse` containing the horizontal size class
    /// - Throws: Errors related to element retrieval
    private func horizontalSizeClass(request: ElementPayload) async throws -> SizeClass {
        let element = try cache.getElement(request.serverId)
        return SizeClass(rawValue: element.horizontalSizeClass.rawValue)!
    }

    /// Retrieves the vertical size class of an element
    ///
    /// This method returns the vertical size class of a specific UI element,
    /// which indicates how the element should be laid out vertically.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A `UserInterfaceSizeClassResponse` containing the vertical size class
    /// - Throws: Errors related to element retrieval
    private func verticalSizeClass(request: ElementPayload) async throws -> SizeClass {
        let element = try cache.getElement(request.serverId)
        return SizeClass(rawValue: element.verticalSizeClass.rawValue)!
    }
}

// MARK: - UIServer + Element Info Routes
extension UIServer {
    /// Registers routes for element information retrieval
    func registerElementInfoRoutes() async {
        let routes = ElementInfoRoutes(cache: cache, routeRegistrar: self)
        await routes.registerRoutes()
    }
}
