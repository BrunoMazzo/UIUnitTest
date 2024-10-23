import Foundation
import XCTest
import UIUnitTestAPI

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
    public func isHittable() async throws -> Bool  {
        let existsRequestData = ElementRequest(serverId: serverId)
        let existsResponse: IsHittableResponse = try await callServer(path: "isHittable", request: existsRequestData)
        return existsResponse.isHittable
    }
    
    // Need better way to represent any :c
    public func value() async throws -> String?  {
        let valueRequest = ElementRequest(serverId: self.serverId)
        let valueResponse: ValueResponse = try await callServer(path: "value", request: valueRequest)
        return valueResponse.value
    }
    
    /** Returns a query for all descendants of the element matching the specified type. */
    public func descendants(matching type: Element.ElementType) async throws -> Query {
        let descendantsFromElement = ElementTypeRequest(serverId: self.serverId, elementType: type.rawValue)
        let queryResponse: QueryResponse = try await callServer(path: "elementDescendants", request: descendantsFromElement)
        return Query(serverId: queryResponse.serverId)
    }
    
    /** Returns a query for direct children of the element matching the specified type. */
    public func children(matching type: Element.ElementType) async throws -> Query {
        let request = ChildrenMatchinType(serverId: self.serverId, elementType: type.rawValue)
        let queryResponse: QueryResponse = try await callServer(path: "children", request: request)
        return Query(serverId: queryResponse.serverId)
    }
    
    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) async throws {
        let activateRequestData = ScrollRequest(serverId: self.serverId, deltaX: deltaX, deltaY: deltaY)
        let _: Bool = try await callServer(path: "scroll", request: activateRequestData)
    }
    
    public func typeText(_ text: String) async throws {
        let activateRequestData = EnterTextRequest(serverId: self.serverId, textToEnter: text)
        let _: Bool = try await callServer(path: "typeText", request: activateRequestData)
    }
    
    public func debugDescription() async throws -> String  {
        try await callServer(path: "debugDescription", request: ElementRequest(serverId: self.serverId))
    }
    
    public func identifier() async throws -> String  {
        return try await callServer(path: "identifier", request: ElementRequest(serverId: self.serverId))
    }
    
    public func title() async throws -> String  {
        return try await callServer(path: "title", request: ElementRequest(serverId: self.serverId))
    }
    
    public func label() async throws -> String  {
        return try await callServer(path: "label", request: ElementRequest(serverId: self.serverId))
    }
    
    public func placeholderValue() async throws -> String?  {
        return try await callServer(path: "placeholderValue", request: ElementRequest(serverId: self.serverId))
    }
    
    public func isSelected() async throws -> Bool  {
        return try await callServer(path: "isSelected", request: ElementRequest(serverId: self.serverId))
    }
    
    public func hasFocus() async throws -> Bool  {
        return try await callServer(path: "hasFocus", request: ElementRequest(serverId: self.serverId))
    }
    
    public func isEnabled() async throws -> Bool  {
        return try await callServer(path: "isEnabled", request: ElementRequest(serverId: self.serverId))
    }
    
    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) async throws -> Coordinate {
        let request = CoordinateRequest(serverId: self.serverId, normalizedOffset: normalizedOffset)
        let response: CoordinateResponse = try await callServer(path: "coordinate", request: request)
        return Coordinate(serverId: response.coordinateId, referencedElement: Element(serverId: response.referencedElementId), screenPoint: response.screenPoint)
    }
    
    public func frame() async throws -> CGRect  {
        return try await callServer(path: "frame", request: ElementRequest(serverId: self.serverId))
    }
    
    public func horizontalSizeClass() async throws -> SizeClass  {
        return try await callServer(path: "horizontalSizeClass", request: ElementRequest(serverId: self.serverId))
    }
    
    public func verticalSizeClass() async throws -> SizeClass  {
        return try await callServer(path: "verticalSizeClass", request: ElementRequest(serverId: self.serverId))
    }
    
    public func elementType() async throws -> ElementType  {
        return try await callServer(path: "elementType", request: ElementRequest(serverId: self.serverId))
    }
    
    public func any() async throws -> Query {
        try await self.descendants(matching: .any)
    }
    
    @available(*, noasync)
    public func any() -> Query {
        Executor.execute {
            try await self.any()
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    public func any(_ identifier: String) async throws -> Element {
        try await self.descendants(matching: .any)(identifier: identifier)
    }
    
    @available(*, noasync)
    public func any(_ identifier: String) -> Element {
        Executor.execute {
            try await self.any(identifier)
        }.valueOrFailWithFallback(.EmptyElement)
    }
}



extension Element {
    
    @discardableResult
    public func assertElementExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) async throws -> Element {
        if (try? await self.exists()) ?? false {
            return self
        }
        
        if (try? await self.waitForExistence(timeout: timeout)) ?? false {
            return self
        } else {
            fail(message ?? "Element \(self.identifier) doesn't exists", fileID: fileID, filePath: filePath, line: line, column: column)
            return self
        }
    }
    
    @discardableResult
    public func assertElementExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) -> Element {
        Executor.execute {
            try await self.assertElementExists(message: message, timeout: timeout, fileID: fileID, filePath: filePath, line: line, column: column)
        }.valueOrFailWithFallback(self)
    }
    
    @discardableResult
    public func assertElementDoesntExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) async throws -> Element {
        if (try? await !self.exists()) ?? false {
            return self
        }
        
        if (try? await self.waitForNonExistence(timeout: timeout)) ?? false {
            return self
        } else {
            fail(message ?? "Element \(self.identifier) exists", fileID: fileID, filePath: filePath, line: line, column: column)
            return self
        }
    }
    
    @discardableResult
    public func assertElementDoesntExists(
        message: String? = nil,
        timeout: TimeInterval = 1,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) -> Element {
        Executor.execute {
            try await self.assertElementDoesntExists(message: message, timeout: timeout, fileID: fileID, filePath: filePath, line: line, column: column)
        }.valueOrFailWithFallback(self)
    }
}
