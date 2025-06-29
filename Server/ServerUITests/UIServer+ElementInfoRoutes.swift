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

    /// Retrieves the identifier of an element
    ///
    /// This method returns the identifier associated with a specific UI element.
    /// The identifier is a string that uniquely identifies the element in the UI hierarchy.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A `StringResponse` containing the element's identifier
    /// - Throws: Errors related to element retrieval
    @MainActor
    func identifier(request: ElementPayload) async throws -> StringResponse {
        let element = try cache.getElement(request.serverId)
        return StringResponse(value: element.identifier)
    }

    /// Retrieves the title of an element
    ///
    /// This method returns the title text associated with a specific UI element.
    /// The title typically represents the main text content or heading of the element.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A `StringResponse` containing the element's title
    /// - Throws: Errors related to element retrieval
    @MainActor
    func title(request: ElementPayload) async throws -> StringResponse {
        let element = try cache.getElement(request.serverId)
        return StringResponse(value: element.title)
    }

    /// Retrieves the label of an element
    ///
    /// This method returns the accessibility label associated with a specific UI element.
    /// The label is typically used for accessibility purposes and describes the element's purpose.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A `StringResponse` containing the element's label
    /// - Throws: Errors related to element retrieval
    @MainActor
    func label(request: ElementPayload) async throws -> StringResponse {
        let element = try cache.getElement(request.serverId)
        return StringResponse(value: element.label)
    }

    /// Retrieves the placeholder value of an element
    ///
    /// This method returns the placeholder text associated with a specific UI element.
    /// The placeholder is typically used in text input fields to provide hints about expected input.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element
    /// - Returns: A `StringResponse` containing the element's placeholder value
    /// - Throws: Errors related to element retrieval
    @MainActor
    func placeholderValue(request: ElementPayload) async throws -> StringResponse {
        let element = try cache.getElement(request.serverId)
        return StringResponse(value: element.placeholderValue)
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
    func elementType(request: ElementPayload) async throws -> ElementTypeResponse {
        let element = try cache.getElement(request.serverId)
        return ElementTypeResponse(elementType: element.elementType.toElementType())
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
    func frame(request: ElementPayload) async throws -> FrameResponse {
        let element = try cache.getElement(request.serverId)
        return FrameResponse(frame: element.frame)
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
    func horizontalSizeClass(request: ElementPayload) async throws -> UserInterfaceSizeClassResponse {
        let element = try cache.getElement(request.serverId)
        return UserInterfaceSizeClassResponse(sizeClass: element.horizontalSizeClass.toUserInterfaceSizeClass())
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
    func verticalSizeClass(request: ElementPayload) async throws -> UserInterfaceSizeClassResponse {
        let element = try cache.getElement(request.serverId)
        return UserInterfaceSizeClassResponse(sizeClass: element.verticalSizeClass.toUserInterfaceSizeClass())
    }
}
