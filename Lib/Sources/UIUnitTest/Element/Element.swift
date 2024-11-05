import Foundation
import UIUnitTestAPI
import XCTest

public class Element: ElementTypeQueryProvider, @unchecked Sendable {
    public static let EmptyElement = Element(serverId: .zero)

    public let serverId: UUID

    public init(serverId: UUID) {
        self.serverId = serverId
    }

    deinit {
        Task { [serverId] in
            let _: Bool = try await callServer(path: "remove", request: RemoveServerItemRequest(serverId: serverId))
        }
    }

    /** Whether or not a hit point can be computed for the element for the purpose of synthesizing events. */
    public var isHittable: Bool {
        get async throws {
            let existsRequestData = ElementRequest(serverId: serverId)
            let existsResponse: IsHittableResponse = try await callServer(path: "isHittable", request: existsRequestData)
            return existsResponse.isHittable
        }
    }

    // Need better way to represent any :c
    public var value: String? {
        get async throws {
            let valueRequest = ElementRequest(serverId: serverId)
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

    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) async throws {
        let activateRequestData = ScrollRequest(serverId: serverId, deltaX: deltaX, deltaY: deltaY)
        let _: Bool = try await callServer(path: "scroll", request: activateRequestData)
    }

    public func typeText(_ text: String) async throws {
        let activateRequestData = EnterTextRequest(serverId: serverId, textToEnter: text)
        let _: Bool = try await callServer(path: "typeText", request: activateRequestData)
    }

    public var debugDescription: String {
        get async throws {
            try await callServer(path: "debugDescription", request: ElementRequest(serverId: serverId))
        }
    }

    public var identifier: String {
        get async throws {
            return try await callServer(path: "identifier", request: ElementRequest(serverId: serverId))
        }
    }

    public var title: String {
        get async throws {
            return try await callServer(path: "title", request: ElementRequest(serverId: serverId))
        }
    }

    public var label: String {
        get async throws {
            return try await callServer(path: "label", request: ElementRequest(serverId: serverId))
        }
    }

    public var placeholderValue: String? {
        get async throws {
            return try await callServer(path: "placeholderValue", request: ElementRequest(serverId: serverId))
        }
    }

    public var isSelected: Bool {
        get async throws {
            return try await callServer(path: "isSelected", request: ElementRequest(serverId: serverId))
        }
    }

    public var hasFocus: Bool {
        get async throws {
            return try await callServer(path: "hasFocus", request: ElementRequest(serverId: serverId))
        }
    }

    public var isEnabled: Bool {
        get async throws {
            return try await callServer(path: "isEnabled", request: ElementRequest(serverId: serverId))
        }
    }

    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) async throws -> Coordinate {
        let request = CoordinateRequest(serverId: serverId, normalizedOffset: normalizedOffset)
        let response: CoordinateResponse = try await callServer(path: "coordinate", request: request)
        return Coordinate(serverId: response.coordinateId, referencedElement: Element(serverId: response.referencedElementId), screenPoint: response.screenPoint)
    }

    public var frame: CGRect {
        get async throws {
            return try await callServer(path: "frame", request: ElementRequest(serverId: serverId))
        }
    }

    public var horizontalSizeClass: SizeClass {
        get async throws {
            return try await callServer(path: "horizontalSizeClass", request: ElementRequest(serverId: serverId))
        }
    }

    public var verticalSizeClass: SizeClass {
        get async throws {
            return try await callServer(path: "verticalSizeClass", request: ElementRequest(serverId: serverId))
        }
    }

    public var elementType: ElementType {
        get async throws {
            return try await callServer(path: "elementType", request: ElementRequest(serverId: serverId))
        }
    }

    public var any: Query {
        get async throws {
            try await descendants(matching: .any)
        }
    }
}

public extension Element {
    @discardableResult
    func assertElementExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) async throws -> Element {
        if (try? await exists()) ?? false {
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

    @discardableResult
    func assertElementDoesntExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) async throws -> Element {
        if (try? await !exists()) ?? false {
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

public class SyncElement: SyncElementTypeQueryProvider, @unchecked Sendable {
    public var queryProvider: any ElementTypeQueryProvider {
        element
    }

    public static let EmptyElement = SyncElement(element: .EmptyElement)

    public let element: Element

    public var serverId: UUID { element.serverId }

    public init(element: Element) {
        self.element = element
    }

    @available(*, noasync)
    public var any: SyncQuery {
        Executor.execute {
            try SyncQuery(query: await self.element.any)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
}

public extension SyncElement {
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
