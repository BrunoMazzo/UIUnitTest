import Foundation
import XCTest

public class Element: ElementTypeQueryProvider, @unchecked Sendable {
    
    static var EmptyElement = Element(serverId: .zero)
    
    public let serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
    
    deinit {
        Task { [serverId] in
            let _: Bool = try await callServer(path: "remove", request: RemoveServerItemRequest(serverId: serverId))
        }
    }
    
    public func exists() async throws ->  Bool {
        let existsRequestData = ElementRequest(serverId: serverId)
        let existsResponse: ExistsResponse = try await callServer(path: "exists", request: existsRequestData)
        return existsResponse.exists
    }
    
    /** Waits the specified amount of time for the element's exist property to be true and returns false if the timeout expires without the element coming into existence. */
    public func waitForExistence(timeout: TimeInterval) async throws -> Bool {
        let activateRequestData = WaitForExistenceRequest(serverId: serverId, timeout: timeout)
        let response: WaitForExistenceResponse = try await callServer(path: "waitForExistence", request: activateRequestData)
        return response.elementExists
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
        let descendantsFromElement = ElementTypeRequest(serverId: self.serverId, elementType: type)
        let queryResponse: QueryResponse = try await callServer(path: "elementDescendants", request: descendantsFromElement)
        return Query(serverId: queryResponse.serverId)
    }
    
    /** Returns a query for direct children of the element matching the specified type. */
    public func children(matching type: Element.ElementType) async throws -> Query {
        let request = ChildrenMatchinType(serverId: self.serverId, elementType: type)
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
}

public struct ScrollRequest: Codable {
    public var serverId: UUID
    public var deltaX: CGFloat
    public var deltaY: CGFloat
    
    init(serverId: UUID, deltaX: CGFloat, deltaY: CGFloat) {
        self.serverId = serverId
        self.deltaX = deltaX
        self.deltaY = deltaY
    }
}

public struct ByIdRequest: Codable {
    public var queryRoot: UUID
    public var identifier: String
}

public struct ElementResponse: Codable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct ElementArrayResponse: Codable {
    public var serversId: [UUID]
    
    public init(serversId: [UUID]) {
        self.serversId = serversId
    }
}

public struct RemoveServerItemRequest: Codable {
    public var serverId: UUID
}

public struct WaitForExistenceRequest: Codable {
    
    public var serverId: UUID
    public var timeout: TimeInterval
    
    public init(serverId: UUID, timeout: TimeInterval) {
        self.serverId = serverId
        self.timeout = timeout
    }
}

public struct WaitForExistenceResponse: Codable {
    public var elementExists: Bool
    
    public init(elementExists: Bool) {
        self.elementExists = elementExists
    }
}

public struct ElementTypeRequest: Codable {
    public let serverId: UUID
    public let elementType: Element.ElementType
    public let identifier: String?
    
    public init(serverId: UUID, elementType: Element.ElementType, identifier: String? = nil) {
        self.serverId = serverId
        self.elementType = elementType
        self.identifier = identifier
    }
}

public struct ChildrenMatchinType: Codable {
    public let serverId: UUID
    public let elementType: Element.ElementType
    
    public init(serverId: UUID, elementType: Element.ElementType) {
        self.serverId = serverId
        self.elementType = elementType
    }
}

public enum SizeClass: Int, Codable {
    case unspecified = 0
    case compact     = 1
    case regular     = 2
}

extension Element {
    
    @discardableResult
    public func assertElementExists(message: String? = nil, timeout: TimeInterval = 1, file: StaticString = #filePath, line: UInt = #line) async throws -> Element {
        guard (try? await self.exists()) ?? false else {
            return self
        }
        
        if (try? await self.waitForExistence(timeout: timeout)) ?? false {
            return self
        } else {
            XCTFail(message ?? "Element \(self.identifier) doesn't exists", file: file, line: line)
            return self
        }
    }
    
    @discardableResult
    public func assertElementExists(message: String? = nil, timeout: TimeInterval = 1, file: StaticString = #filePath, line: UInt = #line) -> Element {
        Executor.execute {
            try await self.assertElementExists(message: message, timeout: timeout, file: file, line: line)
        }.valueOrFailWithFallback(self)
    }
}
