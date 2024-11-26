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
            let _: Bool = try await callServer(path: "remove", request: ElementPayload(serverId: serverId))
        }
    }

    /** Whether or not a hit point can be computed for the element for the purpose of synthesizing events. */
    public func isHittable() async throws -> Bool {
        let existsRequestData = ElementPayload(serverId: serverId)
        let existsResponse: IsHittableResponse = try await callServer(path: "isHittable", request: existsRequestData)
        return existsResponse.isHittable
    }

    // Need better way to represent any :c
    public func value() async throws -> String? {
        let valueRequest = ElementPayload(serverId: serverId)
        let valueResponse: ValueResponse = try await callServer(path: "value", request: valueRequest)
        return valueResponse.value
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

    public func debugDescription() async throws -> String {
        try await callServer(path: "debugDescription", request: ElementPayload(serverId: serverId))
    }

    public func identifier() async throws -> String {
        return try await callServer(path: "identifier", request: ElementPayload(serverId: serverId))
    }

    public func title() async throws -> String {
        return try await callServer(path: "title", request: ElementPayload(serverId: serverId))
    }

    public func label() async throws -> String {
        return try await callServer(path: "label", request: ElementPayload(serverId: serverId))
    }

    public func placeholderValue() async throws -> String? {
        return try await callServer(path: "placeholderValue", request: ElementPayload(serverId: serverId))
    }

    public func isSelected() async throws -> Bool {
        return try await callServer(path: "isSelected", request: ElementPayload(serverId: serverId))
    }

    public func hasFocus() async throws -> Bool {
        return try await callServer(path: "hasFocus", request: ElementPayload(serverId: serverId))
    }

    public func isEnabled() async throws -> Bool {
        return try await callServer(path: "isEnabled", request: ElementPayload(serverId: serverId))
    }

    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) async throws -> Coordinate {
        let request = CoordinateRequest(serverId: serverId, normalizedOffset: normalizedOffset)
        let response: CoordinateResponse = try await callServer(path: "coordinate", request: request)
        return Coordinate(serverId: response.coordinateId, referencedElement: Element(serverId: response.referencedElementId), screenPoint: response.screenPoint)
    }

    public func frame() async throws -> CGRect {
        return try await callServer(path: "frame", request: ElementPayload(serverId: serverId))
    }

    public func horizontalSizeClass() async throws -> SizeClass {
        return try await callServer(path: "horizontalSizeClass", request: ElementPayload(serverId: serverId))
    }

    public func verticalSizeClass() async throws -> SizeClass {
        return try await callServer(path: "verticalSizeClass", request: ElementPayload(serverId: serverId))
    }

    public func elementType() async throws -> ElementType {
        return try await callServer(path: "elementType", request: ElementPayload(serverId: serverId))
    }

    public func any() async throws -> Query {
        try await descendants(matching: .any)
    }

    @available(*, noasync)
    public func any() -> Query {
        Executor.execute {
            try await self.any()
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    public func any(_ identifier: String) async throws -> Element {
        try await descendants(matching: .any)(identifier: identifier)
    }

    @available(*, noasync)
    public func any(_ identifier: String) -> Element {
        Executor.execute {
            try await self.any(identifier)
        }.valueOrFailWithFallback(.EmptyElement)
    }
}

public enum SizeClass: Int, Codable, Sendable {
    case unspecified = 0
    case compact = 1
    case regular = 2
}

public extension Element {
    @discardableResult
    func assertElementExists(message: String? = nil, timeout: TimeInterval = 1, file: StaticString = #filePath, line: UInt = #line) async throws -> Element {
        if (try? await exists()) ?? false {
            return self
        }

        if (try? await waitForExistence(timeout: timeout)) ?? false {
            return self
        } else {
            XCTFail(message ?? "Element \(identifier) doesn't exists", file: file, line: line)
            return self
        }
    }

    @discardableResult
    func assertElementExists(message: String? = nil, timeout: TimeInterval = 1, file: StaticString = #filePath, line: UInt = #line) -> Element {
        Executor.execute {
            try await self.assertElementExists(message: message, timeout: timeout, file: file, line: line)
        }.valueOrFailWithFallback(self)
    }

    @discardableResult
    func assertElementDoesntExists(message: String? = nil, timeout: TimeInterval = 1, file: StaticString = #filePath, line: UInt = #line) async throws -> Element {
        if (try? await !exists()) ?? false {
            return self
        }

        if (try? await waitForNonExistence(timeout: timeout)) ?? false {
            return self
        } else {
            XCTFail(message ?? "Element \(identifier) exists", file: file, line: line)
            return self
        }
    }

    @discardableResult
    func assertElementDoesntExists(message: String? = nil, timeout: TimeInterval = 1, file: StaticString = #filePath, line: UInt = #line) -> Element {
        Executor.execute {
            try await self.assertElementDoesntExists(message: message, timeout: timeout, file: file, line: line)
        }.valueOrFailWithFallback(self)
    }
}
