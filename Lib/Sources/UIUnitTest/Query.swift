import Foundation

public final class Query: ElementTypeQueryProvider, Sendable {
    
    public let serverId: UUID
    
    init(serverId: UUID) {
        self.serverId = serverId
    }
    
    init(serverId: UUID, queryType: QueryType) async throws {
        let response: QueryResponse = try await callServer(path: "query", request: QueryRequest(serverId: serverId, queryType: queryType))
        self.serverId = response.serverId
    }
    
    deinit {
        Task { [serverId] in
            let _: Bool = try await callServer(path: "remove", request: RemoveServerItemRequest(serverId: serverId))
        }
    }
    
    /** Returns an element that will use the query for resolution. */
    public func element() async throws -> Element!  {
        let elementResponse: ElementResponse = try await callServer(path: "elementFromQuery", request: ElementFromQuery(serverId: self.serverId))
            return Element(serverId: elementResponse.serverId)
    }
    
    @available(*, noasync)
    public var element: Element! {
        Executor.execute {
            try await self.element()
        }
    }
    
    public func allElementsBoundByAccessibilityElement() async throws -> [Element] {
        let elementResponse: ElementArrayResponse = try await callServer(path: "allElementsBoundByAccessibilityElement", request: ElementsByAccessibility(serverId: self.serverId))
        return elementResponse.serversId.map { Element(serverId: $0) }
    }
    
    @available(*, noasync)
    public var allElementsBoundByAccessibilityElement: [Element] {
        Executor.execute {
            try await self.allElementsBoundByAccessibilityElement()
        }
    }
    
    public func allElementsBoundByIndex() async throws -> [Element] {
        let elementResponse: ElementArrayResponse = try await callServer(path: "allElementsBoundByIndex", request: ElementsByAccessibility(serverId: self.serverId))
        return elementResponse.serversId.map { Element(serverId: $0) }
    }
    
    @available(*, noasync)
    public var allElementsBoundByIndex: [Element] {
        Executor.execute {
            try await self.allElementsBoundByIndex()
        }
    }
    
    /** Evaluates the query at the time it is called and returns the number of matches found. */
    public func count() async throws -> Int  {
        let response: CountResponse = try await callServer(path: "count", request: CountRequest(serverId: self.serverId))
        return response.count
    }
    
    @available(*, noasync)
    public var count: Int {
        Executor.execute {
            try await self.count()
        }
    }
    
    public func element(boundByIndex index: Int) async throws -> Element {
        let elementResponse: ElementResponse = try await callServer(path: "elementFromQuery", request: ElementFromQuery(serverId: self.serverId, index: index))
        return Element(serverId: elementResponse.serverId)
    }
    
    @available(*, noasync)
    public func element(boundByIndex index: Int) -> Element {
        Executor.execute {
            try await self.element(boundByIndex: index)
        }
    }
    
    // Using autoclosure to erase the Sendable warning
    public func element(matching predicate: @Sendable @autoclosure () -> NSPredicate) async throws -> Element {
        let response: ElementResponse = try await callServer(path: "elementMatchingPredicate", request: PredicateRequest(serverId: self.serverId, predicate: predicate()))
        return Element(serverId: response.serverId)
    }
    
    @available(*, noasync)
    // Using autoclosure to erase the Sendable warning
    public func element(matching predicate: @Sendable @autoclosure @escaping () -> NSPredicate) -> Element {
        Executor.execute {
            try await self.element(matching: predicate())
        }
    }
    
    public func element(matching elementType: Element.ElementType, identifier: String?) async throws -> Element {
        let response: ElementResponse = try await callServer(path: "elementMatchingPredicate", request: ElementFromQuery(serverId: self.serverId, elementType: elementType, identifier: identifier))
        return Element(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func element(matching elementType: Element.ElementType, identifier: String?) -> Element {
        Executor.execute {
            try await self.element(matching: elementType, identifier: identifier)
        }
    }
    
    public func callAsFunction(identifier: String) async throws -> Element {
        let response: ElementResponse = try await callServer(path: "element", request: ByIdRequest(queryRoot: serverId, identifier: identifier))
        return Element(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public subscript(_ identifier: String) -> Element {
        Executor.execute {
            try await self(identifier: identifier)
        }
    }
    
    public func descendants(matching elementType: Element.ElementType) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "queryDescendants", request: DescendantsFromQuery(serverId: self.serverId, elementType: elementType))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func descendants(matching elementType: Element.ElementType) -> Query {
        Executor.execute {
            try await self.descendants(matching: elementType)
        }
    }

    public func children(matching type: Element.ElementType) async throws -> Query {
        let request = ChildrenMatchinType(serverId: self.serverId, elementType: type)
        let queryResponse: QueryResponse = try await callServer(path: "children", request: request)
        return Query(serverId: queryResponse.serverId)
    }
    
    @available(*, noasync)
    public func children(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.children(matching: type)
        }
    }
    
    public func matching(_ predicate: NSPredicate) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "matchingPredicate", request: PredicateRequest(serverId: self.serverId, predicate: predicate))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func matching(_ predicate: NSPredicate) -> Query {
        Executor.execute {
            try await self.matching(predicate)
        }
    }
    
    public func matching(_ elementType: Element.ElementType, identifier: String?) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "matchingElementType", request: ElementTypeRequest(serverId: self.serverId, elementType: elementType, identifier: identifier))
        return Query(serverId: response.serverId)
    }
    
    
    @available(*, noasync)
    public func matching(_ elementType: Element.ElementType, identifier: String?) -> Query {
        Executor.execute {
            try await self.matching(elementType, identifier: identifier)
        }
    }
    
    public func matching(identifier: String) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "matchingByIdentifier", request: ByIdRequest(queryRoot: self.serverId, identifier: identifier))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func matching(identifier: String) -> Query {
        Executor.execute {
            try await self.matching(identifier: identifier)
        }
    }
    
    public func containing(_ predicate: NSPredicate) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "containingPredicate", request: PredicateRequest(serverId: self.serverId, predicate: predicate))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func containing(_ predicate: NSPredicate) -> Query {
        Executor.execute {
            try await self.containing(predicate)
        }
    }
    
    public func containing(_ elementType: Element.ElementType, identifier: String?) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "containingElementType", request: ElementTypeRequest(serverId: self.serverId, elementType: elementType, identifier: identifier))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func containing(_ elementType: Element.ElementType, identifier: String?) -> Query {
        Executor.execute {
            try await self.containing(elementType, identifier: identifier)
        }
    }
    
    public func debugDescription() async throws -> String {
        let valueResponse: ValueResponse = try await callServer(path: "debugDescription", request: ElementRequest(serverId: self.serverId))
        return valueResponse.value!
    }
    
    @available(*, noasync)
    public var debugDescription: String {
        Executor.execute {
            try await self.debugDescription()
        }
    }
}

public struct QueryRequest: Codable {
    
    public var serverId: UUID
    public var queryType: Query.QueryType
    
    init(serverId: UUID, queryType: Query.QueryType) {
        self.serverId = serverId
        self.queryType = queryType
    }
}

public struct QueryResponse: Codable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct CountRequest: Codable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct CountResponse: Codable {
    public var count: Int
    
    public init(count: Int) {
        self.count = count
    }
}

public struct PredicateRequest: Codable {
    public let serverId: UUID
    public let predicate: NSPredicate
            
    public init(serverId: UUID, predicate: NSPredicate) {
        self.serverId = serverId
        self.predicate = predicate
    }
    
    enum CodingKeys: CodingKey {
        case serverId
        case predicate
    }
    
    public func encode(to encoder: Encoder) throws {
        let data = try NSKeyedArchiver.archivedData(
            withRootObject: predicate,
            requiringSecureCoding: true
        )
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serverId, forKey: .serverId)
        try container.encode(data, forKey: .predicate)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.serverId = try container.decode(UUID.self, forKey: .serverId)
        
        let data = try container.decode(Data.self, forKey: .predicate)

        self.predicate = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSPredicate.self], from:data) as! NSPredicate
    }
}

public struct ElementFromQuery: Codable {
    public let serverId: UUID
    public let index: Int?
    public let elementType: Element.ElementType?
    public let identifier: String?
    
    public init(serverId: UUID, index: Int? = nil) {
        self.serverId = serverId
        self.index = index
        self.elementType = nil
        self.identifier = nil
    }
    
    public init(serverId: UUID, elementType: Element.ElementType, identifier: String? = nil) {
        self.serverId = serverId
        self.elementType = elementType
        self.identifier = identifier
        self.index = nil
    }
}


public struct DescendantsFromQuery: Codable {
    public let serverId: UUID
    public let elementType: Element.ElementType
    
    public init(serverId: UUID, elementType: Element.ElementType) {
        self.serverId = serverId
        self.elementType = elementType
    }
}

public struct ElementsByAccessibility: Codable {
    public let serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}


