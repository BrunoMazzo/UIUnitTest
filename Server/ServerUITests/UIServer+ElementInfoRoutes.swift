import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Element Info Routes
extension UIServer {
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
    func registerElementInfoRoutes() async {
        await addRoute("identifier", handler: identifier(request:))
        await addRoute("title", handler: title(request:))
        await addRoute("label", handler: label(request:))
        await addRoute("placeholderValue", handler: placeholderValue(request:))
        await addRoute("isSelected", handler: isSelected(request:))
        await addRoute("hasFocus", handler: hasFocus(request:))
        await addRoute("isEnabled", handler: isEnabled(request:))
        await addRoute("elementType", handler: elementType(request:))
        await addRoute("frame", handler: frame(request:))
        await addRoute("horizontalSizeClass", handler: horizontalSizeClass(request:))
        await addRoute("verticalSizeClass", handler: verticalSizeClass(request:))
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
    @MainActor
    func isSelected(request: ElementPayload) async throws -> Bool {
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
    @MainActor
    func hasFocus(request: ElementPayload) async throws -> Bool {
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
    @MainActor
    func isEnabled(request: ElementPayload) async throws -> Bool {
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
    @MainActor
    func elementType(request: ElementPayload) async throws -> UInt {
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
    @MainActor
    func frame(request: ElementPayload) async throws -> CGRect {
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
    @MainActor
    func horizontalSizeClass(request: ElementPayload) async throws -> SizeClass {
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
    @MainActor
    func verticalSizeClass(request: ElementPayload) async throws -> SizeClass {
        let element = try cache.getElement(request.serverId)
        return SizeClass(rawValue: element.verticalSizeClass.rawValue)!
    }
}
