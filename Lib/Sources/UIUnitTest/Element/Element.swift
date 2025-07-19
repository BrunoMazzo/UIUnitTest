import Foundation
import UIUnitTestAPI
import XCTest

/// A proxy representing a UI element in the target application.
///
/// `Element` provides a set of methods and properties to interact with and query UI elements,
/// such as buttons, text fields, and labels. It communicates with a server running in the app
/// to perform actions and retrieve element information.
public class Element: ElementTypeQueryProvider, @unchecked Sendable {
    /// A special element representing an empty or non-existent element.
    public static let EmptyElement = Element(serverId: .zero)

    /// The unique identifier for the server-side representation of this element.
    public let serverId: UUID

    /// Initializes a new `Element` with a server ID.
    ///
    /// - Parameter serverId: The unique identifier for the element on the server.
    public init(serverId: UUID) {
        self.serverId = serverId
    }

    deinit {
        Task { [serverId] in
            let _: Bool = try await callServer(path: "remove", request: ElementPayload(serverId: serverId))
        }
    }

    /** Whether or not a hit point can be computed for the element for the purpose of synthesizing events. */
    public var isHittable: Bool {
        get async throws {
            let existsRequestData = ElementPayload(serverId: serverId)
            let existsResponse: IsHittableResponse = try await callServer(path: "isHittable", request: existsRequestData)
            return existsResponse.isHittable
        }
    }

    /// The value of the element, such as the text of a text field or the value of a slider.
    ///
    /// - Note: The type of the value can vary depending on the element.
    public var value: String? {
        get async throws {
            let valueRequest = ElementPayload(serverId: serverId)
            let valueResponse: ValueResponse = try await callServer(path: "value", request: valueRequest)
            return valueResponse.value
        }
    }

    /** Returns a query for all descendants of the element matching the specified type. */
    public func descendants(matching type: Element.ElementType) async throws -> Query {
        let descendantsFromElement = ElementTypeRequest(serverId: serverId, elementType: type.rawValue)
        let queryResponse: QueryResponse = try await callServer(path: "elementDescendants", request: descendantsFromElement)
        return Query(serverId: queryResponse.serverId)
    }

    /** Returns a query for direct children of the element matching the specified type. */
    public func children(matching type: Element.ElementType) async throws -> Query {
        let request = ChildrenMatchinType(serverId: serverId, elementType: type.rawValue)
        let queryResponse: QueryResponse = try await callServer(path: "children", request: request)
        return Query(serverId: queryResponse.serverId)
    }

    /// Scrolls the element by a specified amount.
    ///
    /// - Parameters:
    ///   - deltaX: The horizontal distance to scroll.
    ///   - deltaY: The vertical distance to scroll.
    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) async throws {
        let activateRequestData = ScrollRequest(serverId: serverId, deltaX: deltaX, deltaY: deltaY)
        let _: Bool = try await callServer(path: "scroll", request: activateRequestData)
    }

    /// Types the given text into the element.
    ///
    /// - Parameter text: The text to type.
    public func typeText(_ text: String) async throws {
        let activateRequestData = EnterTextRequest(serverId: serverId, textToEnter: text)
        let _: Bool = try await callServer(path: "typeText", request: activateRequestData)
    }

    /// A string containing a detailed description of the element and its descendants.
    public var debugDescription: String {
        get async throws {
            try await callServer(path: "debugDescription", request: ElementPayload(serverId: serverId))
        }
    }

    /// The identifier of the element.
    public var identifier: String {
        get async throws {
            return try await callServer(path: "identifier", request: ElementPayload(serverId: serverId))
        }
    }

    /// The title of the element.
    public var title: String {
        get async throws {
            return try await callServer(path: "title", request: ElementPayload(serverId: serverId))
        }
    }

    /// The label of the element.
    public var label: String {
        get async throws {
            return try await callServer(path: "label", request: ElementPayload(serverId: serverId))
        }
    }

    /// The placeholder value of the element.
    public var placeholderValue: String? {
        get async throws {
            return try await callServer(path: "placeholderValue", request: ElementPayload(serverId: serverId))
        }
    }

    /// A Boolean value that indicates whether the element is selected.
    public var isSelected: Bool {
        get async throws {
            return try await callServer(path: "isSelected", request: ElementPayload(serverId: serverId))
        }
    }

    /// A Boolean value that indicates whether the element has keyboard focus.
    public var hasFocus: Bool {
        get async throws {
            return try await callServer(path: "hasFocus", request: ElementPayload(serverId: serverId))
        }
    }

    /// A Boolean value that indicates whether the element is enabled.
    public var isEnabled: Bool {
        get async throws {
            return try await callServer(path: "isEnabled", request: ElementPayload(serverId: serverId))
        }
    }

    /// Returns a coordinate within the element's frame.
    ///
    /// - Parameter normalizedOffset: A vector with values from 0.0 to 1.0, where (0.0, 0.0) is the top-left corner and (1.0, 1.0) is the bottom-right corner.
    /// - Returns: A `Coordinate` object representing the point.
    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) async throws -> Coordinate {
        let request = CoordinateRequest(serverId: serverId, normalizedOffset: normalizedOffset)
        let response: CoordinateResponse = try await callServer(path: "coordinate", request: request)
        return Coordinate(
            serverId: response.coordinateId,
            referencedElement: Element(serverId: response.referencedElementId),
            screenPoint: response.screenPoint
        )
    }

    /// The frame of the element in screen coordinates.
    public var frame: CGRect {
        get async throws {
            return try await callServer(path: "frame", request: ElementPayload(serverId: serverId))
        }
    }

    /// The horizontal size class of the element.
    public var horizontalSizeClass: SizeClass {
        get async throws {
            return try await callServer(path: "horizontalSizeClass", request: ElementPayload(serverId: serverId))
        }
    }

    /// The vertical size class of the element.
    public var verticalSizeClass: SizeClass {
        get async throws {
            return try await callServer(path: "verticalSizeClass", request: ElementPayload(serverId: serverId))
        }
    }

    /// The type of the element.
    public var elementType: ElementType {
        get async throws {
            return try await callServer(path: "elementType", request: ElementPayload(serverId: serverId))
        }
    }

    /// A query for all descendants of the element.
    public var any: Query {
        get async throws {
            try await descendants(matching: .any)
        }
    }
}

public extension Element {
    /// Asserts that the element exists.
    ///
    /// - Parameters:
    ///   - message: An optional failure message.
    ///   - timeout: The amount of time to wait for the element to exist.
    ///   - fileID: The file ID of the test.
    ///   - filePath: The file path of the test.
    ///   - line: The line number of the test.
    ///   - column: The column number of the test.
    /// - Returns: The element, if it exists.
    @discardableResult
    func assertElementExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) async throws -> Element {
        if (try? await exists) ?? false {
            return self
        }

        if (try? await waitForExistence(timeout: timeout)) ?? false {
            return self
        } else {
            if let message {
                fail(message, fileID: fileID, filePath: filePath, line: line, column: column)
            } else {
                let fallbackMessage = try await "Element \(identifier) doesn't exists"
                fail(fallbackMessage, fileID: fileID, filePath: filePath, line: line, column: column)
            }

            return self
        }
    }

    /// Asserts that the element does not exist.
    ///
    /// - Parameters:
    ///   - message: An optional failure message.
    ///   - timeout: The amount of time to wait for the element to not exist.
    ///   - fileID: The file ID of the test.
    ///   - filePath: The file path of the test.
    ///   - line: The line number of the test.
    ///   - column: The column number of the test.
    /// - Returns: The element, if it does not exist.
    @discardableResult
    func assertElementDoesntExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) async throws -> Element {
        if (try? await !exists) ?? false {
            return self
        }

        if (try? await waitForNonExistence(timeout: timeout)) ?? false {
            return self
        } else {
            if let message {
                fail(message, fileID: fileID, filePath: filePath, line: line, column: column)
            } else {
                let fallbackMessage = try await "Element \(identifier) exists"
                fail(fallbackMessage, fileID: fileID, filePath: filePath, line: line, column: column)
            }
            return self
        }
    }
}

/// A synchronous wrapper for `Element`.
public class SyncElement: SyncElementTypeQueryProvider, @unchecked Sendable {
    public var queryProvider: any ElementTypeQueryProvider {
        element
    }

    /// A special element representing an empty or non-existent element.
    public static let EmptyElement = SyncElement(element: .EmptyElement)

    /// The underlying asynchronous `Element`.
    public let element: Element

    /// The unique identifier for the server-side representation of this element.
    public var serverId: UUID { element.serverId }

    /// Initializes a new `SyncElement` with an `Element`.
    ///
    /// - Parameter element: The underlying asynchronous `Element`.
    public init(element: Element) {
        self.element = element
    }

    /// A query for all descendants of the element.
    @available(*, noasync)
    public var any: SyncQuery {
        Executor.execute {
            try SyncQuery(query: await self.element.any)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
}

public extension SyncElement {
    /// Asserts that the element exists.
    ///
    /// - Parameters:
    ///   - message: An optional failure message.
    ///   - timeout: The amount of time to wait for the element to exist.
    ///   - fileID: The file ID of the test.
    ///   - filePath: The file path of the test.
    ///   - line: The line number of the test.
    ///   - column: The column number of the test.
    /// - Returns: The element, if it exists.
    @discardableResult
    func assertElementExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) -> SyncElement {
        Executor.execute {
            try SyncElement(element: await self.element.assertElementExists(message: message, timeout: timeout, fileID: fileID, filePath: filePath, line: line, column: column))
        }.valueOrFailWithFallback(self)
    }

    /// Asserts that the element does not exist.
    ///
    /// - Parameters:
    ///   - message: An optional failure message.
    ///   - timeout: The amount of time to wait for the element to not exist.
    ///   - fileID: The file ID of the test.
    ///   - filePath: The file path of the test.
    ///   - line: The line number of the test.
    ///   - column: The column number of the test.
    /// - Returns: The element, if it does not exist.
    @discardableResult
    func assertElementDoesntExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) -> SyncElement {
        Executor.execute {
            try SyncElement(element: await self.element.assertElementDoesntExists(message: message, timeout: timeout, fileID: fileID, filePath: filePath, line: line, column: column))
        }.valueOrFailWithFallback(self)
    }
}
