import Foundation
import UIUnitTestAPI

public final class Query: ElementTypeQueryProvider, Sendable {
    
    public static let EmptyQuery = Query(serverId: UUID.zero)
    
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
        }.valueOrFailWithFallback(nil)
    }
    
    public func allElementsBoundByAccessibilityElement() async throws -> [Element] {
        let elementResponse: ElementArrayResponse = try await callServer(path: "allElementsBoundByAccessibilityElement", request: ElementsByAccessibility(serverId: self.serverId))
        return elementResponse.serversId.map { Element(serverId: $0) }
    }
    
    @available(*, noasync)
    public var allElementsBoundByAccessibilityElement: [Element] {
        Executor.execute {
            try await self.allElementsBoundByAccessibilityElement()
        }.valueOrFailWithFallback([])
    }
    
    public func allElementsBoundByIndex() async throws -> [Element] {
        let elementResponse: ElementArrayResponse = try await callServer(path: "allElementsBoundByIndex", request: ElementsByAccessibility(serverId: self.serverId))
        return elementResponse.serversId.map { Element(serverId: $0) }
    }
    
    @available(*, noasync)
    public var allElementsBoundByIndex: [Element] {
        Executor.execute {
            try await self.allElementsBoundByIndex()
        }.valueOrFailWithFallback([])
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
        }.valueOrFailWithFallback(-1)
    }
    
    public func element(boundByIndex index: Int) async throws -> Element {
        let elementResponse: ElementResponse = try await callServer(path: "elementFromQuery", request: ElementFromQuery(serverId: self.serverId, index: index))
        return Element(serverId: elementResponse.serverId)
    }
    
    @available(*, noasync)
    public func element(boundByIndex index: Int) -> Element {
        Executor.execute {
            try await self.element(boundByIndex: index)
        }.valueOrFailWithFallback(.EmptyElement)
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
        }.valueOrFailWithFallback(.EmptyElement)
    }
    
    public func element(matching elementType: Element.ElementType, identifier: String?) async throws -> Element {
        let response: ElementResponse = try await callServer(path: "elementMatchingPredicate", request: ElementFromQuery(serverId: self.serverId, elementType: elementType.rawValue, identifier: identifier))
        return Element(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func element(matching elementType: Element.ElementType, identifier: String?) -> Element {
        Executor.execute {
            try await self.element(matching: elementType, identifier: identifier)
        }.valueOrFailWithFallback(.EmptyElement)
    }
    
    public func callAsFunction(identifier: String) async throws -> Element {
        let response: ElementResponse = try await callServer(path: "element", request: ByIdRequest(queryRoot: serverId, identifier: identifier))
        return Element(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public subscript(_ identifier: String) -> Element {
        Executor.execute {
            try await self(identifier: identifier)
        }.valueOrFailWithFallback(.EmptyElement)
    }
    
    public func descendants(matching elementType: Element.ElementType) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "queryDescendants", request: DescendantsFromQuery(serverId: self.serverId, elementType: elementType.rawValue))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func descendants(matching elementType: Element.ElementType) -> Query {
        Executor.execute {
            try await self.descendants(matching: elementType)
        }.valueOrFailWithFallback(.EmptyQuery)
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

    public func children(matching type: Element.ElementType) async throws -> Query {
        let request = ChildrenMatchinType(serverId: self.serverId, elementType: type.rawValue)
        let queryResponse: QueryResponse = try await callServer(path: "children", request: request)
        return Query(serverId: queryResponse.serverId)
    }
    
    @available(*, noasync)
    public func children(matching type: Element.ElementType) -> Query {
        Executor.execute {
            try await self.children(matching: type)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    public func matching(_ predicate: NSPredicate) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "matchingPredicate", request: PredicateRequest(serverId: self.serverId, predicate: predicate))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func matching(_ predicate: NSPredicate) -> Query {
        let sendablebox = NSPredicateSendableBox(predicate: predicate)
        return Executor.execute {
            try await self.matching(sendablebox.predicate)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    public func matching(_ elementType: Element.ElementType, identifier: String?) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "matchingElementType", request: ElementTypeRequest(serverId: self.serverId, elementType: elementType.rawValue, identifier: identifier))
        return Query(serverId: response.serverId)
    }
    
    
    @available(*, noasync)
    public func matching(_ elementType: Element.ElementType, identifier: String?) -> Query {
        Executor.execute {
            try await self.matching(elementType, identifier: identifier)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    public func matching(identifier: String) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "matchingByIdentifier", request: ByIdRequest(queryRoot: self.serverId, identifier: identifier))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func matching(identifier: String) -> Query {
        Executor.execute {
            try await self.matching(identifier: identifier)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    public func containing(_ predicate: NSPredicate) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "containingPredicate", request: PredicateRequest(serverId: self.serverId, predicate: predicate))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func containing(_ predicate: NSPredicate) -> Query {
        let sendablebox = NSPredicateSendableBox(predicate: predicate)
        return Executor.execute {
            try await self.containing(sendablebox.predicate)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    public func containing(_ elementType: Element.ElementType, identifier: String?) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "containingElementType", request: ElementTypeRequest(serverId: self.serverId, elementType: elementType.rawValue, identifier: identifier))
        return Query(serverId: response.serverId)
    }
    
    @available(*, noasync)
    public func containing(_ elementType: Element.ElementType, identifier: String?) -> Query {
        Executor.execute {
            try await self.containing(elementType, identifier: identifier)
        }.valueOrFailWithFallback(.EmptyQuery)
    }
    
    public func debugDescription() async throws -> String {
        let valueResponse: ValueResponse = try await callServer(path: "debugDescription", request: ElementRequest(serverId: self.serverId))
        return valueResponse.value!
    }
    
    @available(*, noasync)
    public var debugDescription: String {
        Executor.execute {
            try await self.debugDescription()
        }.valueOrFailWithFallback("")
    }
}



extension UUID {
    static let zero = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
}

final class NSPredicateSendableBox: @unchecked Sendable {
    let predicate: NSPredicate
    
    init(predicate: NSPredicate) {
        self.predicate = predicate
    }
}
