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
            let _: Bool = try await callServer(path: "remove", request: ElementPayload(serverId: serverId))
        }
    }

    /** Returns an element that will use the query for resolution. */
    public func element() async throws -> Element! {
        let elementResponse: ElementPayload = try await callServer(path: "elementFromQuery", request: ElementFromQuery(serverId: serverId))
        return Element(serverId: elementResponse.serverId)
    }

    public func allElementsBoundByAccessibilityElement() async throws -> [Element] {
        let elementResponse: ElementArrayResponse = try await callServer(path: "allElementsBoundByAccessibilityElement", request: ElementsByAccessibility(serverId: serverId))
        return elementResponse.serversId.map { Element(serverId: $0) }
    }

    public func allElementsBoundByIndex() async throws -> [Element] {
        let elementResponse: ElementArrayResponse = try await callServer(path: "allElementsBoundByIndex", request: ElementsByAccessibility(serverId: serverId))
        return elementResponse.serversId.map { Element(serverId: $0) }
    }

    /** Evaluates the query at the time it is called and returns the number of matches found. */
    public func count() async throws -> Int {
        let response: CountResponse = try await callServer(path: "count", request: CountRequest(serverId: serverId))
        return response.count
    }

    public func element(boundByIndex index: Int) async throws -> Element {
        let elementResponse: ElementPayload = try await callServer(path: "elementFromQuery", request: ElementFromQuery(serverId: serverId, index: index))
        return Element(serverId: elementResponse.serverId)
    }

    // Using autoclosure to erase the Sendable warning
    public func element(matching predicate: @Sendable @autoclosure () -> NSPredicate) async throws -> Element {
        let response: ElementPayload = try await callServer(path: "elementMatchingPredicate", request: PredicateRequest(serverId: serverId, predicate: predicate()))
        return Element(serverId: response.serverId)
    }

    public func element(matching elementType: Element.ElementType, identifier: String?) async throws -> Element {
        let response: ElementPayload = try await callServer(path: "elementMatchingPredicate", request: ElementFromQuery(serverId: serverId, elementType: elementType.rawValue, identifier: identifier))
        return Element(serverId: response.serverId)
    }

    public subscript(identifier: String) -> Element {
        get async throws {
            let response: ElementPayload = try await callServer(path: "element", request: ByIdRequest(queryRoot: serverId, identifier: identifier))
            return Element(serverId: response.serverId)
        }
    }

    public func descendants(matching elementType: Element.ElementType) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "queryDescendants", request: DescendantsFromQuery(serverId: serverId, elementType: elementType.rawValue))
        return Query(serverId: response.serverId)
    }

    public var any: Query {
        get async throws {
            try await descendants(matching: .any)
        }
    }

    public func children(matching type: Element.ElementType) async throws -> Query {
        let request = ChildrenMatchinType(serverId: serverId, elementType: type.rawValue)
        let queryResponse: QueryResponse = try await callServer(path: "children", request: request)
        return Query(serverId: queryResponse.serverId)
    }

    public func matching(_ predicate: NSPredicate) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "matchingPredicate", request: PredicateRequest(serverId: serverId, predicate: predicate))
        return Query(serverId: response.serverId)
    }

    public func matching(_ elementType: Element.ElementType, identifier: String?) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "matchingElementType", request: ElementTypeRequest(serverId: serverId, elementType: elementType.rawValue, identifier: identifier))
        return Query(serverId: response.serverId)
    }

    public func matching(identifier: String) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "matchingByIdentifier", request: ByIdRequest(queryRoot: serverId, identifier: identifier))
        return Query(serverId: response.serverId)
    }

    public func containing(_ predicate: NSPredicate) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "containingPredicate", request: PredicateRequest(serverId: serverId, predicate: predicate))
        return Query(serverId: response.serverId)
    }

    public func containing(_ elementType: Element.ElementType, identifier: String?) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "containingElementType", request: ElementTypeRequest(serverId: serverId, elementType: elementType.rawValue, identifier: identifier))
        return Query(serverId: response.serverId)
    }

    public func debugDescription() async throws -> String {
        let valueResponse: ValueResponse = try await callServer(path: "debugDescription", request: ElementPayload(serverId: serverId))
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

public final class SyncQuery: SyncElementTypeQueryProvider, Sendable {
    public static var EmptyQuery: SyncQuery { SyncQuery(query: .EmptyQuery) }

    public var queryProvider: any ElementTypeQueryProvider {
        query
    }

    public let query: Query

    init(query: Query) {
        self.query = query
    }

    @available(*, noasync)
    public var element: SyncElement! {
        Executor.execute {
            try SyncElement(element: await self.query.element())
        }.valueOrFailWithFallback(nil)
    }

    @available(*, noasync)
    public var allElementsBoundByAccessibilityElement: [SyncElement] {
        Executor.execute {
            try await self.query.allElementsBoundByAccessibilityElement().map {
                SyncElement(element: $0)
            }
        }.valueOrFailWithFallback([])
    }

    @available(*, noasync)
    public var allElementsBoundByIndex: [SyncElement] {
        Executor.execute {
            try await self.query.allElementsBoundByIndex().map {
                SyncElement(element: $0)
            }
        }.valueOrFailWithFallback([])
    }

    @available(*, noasync)
    public var count: Int {
        Executor.execute {
            try await self.query.count()
        }.valueOrFailWithFallback(-1)
    }

    @available(*, noasync)
    public func element(boundByIndex index: Int) -> SyncElement {
        Executor.execute {
            try SyncElement(element: await self.query.element(boundByIndex: index))
        }.valueOrFailWithFallback(.EmptyElement)
    }

    @available(*, noasync)
    // Using autoclosure to erase the Sendable warning
    public func element(matching predicate: @Sendable @autoclosure @escaping () -> NSPredicate) -> SyncElement {
        Executor.execute {
            try SyncElement(element: await self.query.element(matching: predicate()))
        }.valueOrFailWithFallback(.EmptyElement)
    }

    @available(*, noasync)
    public func element(matching elementType: Element.ElementType, identifier: String?) -> SyncElement {
        Executor.execute {
            try SyncElement(element: await self.query.element(matching: elementType, identifier: identifier))
        }.valueOrFailWithFallback(.EmptyElement)
    }

    @available(*, noasync)
    public subscript(_ identifier: String) -> SyncElement {
        Executor.execute {
            try SyncElement(element: await self.query[identifier])
        }.valueOrFailWithFallback(.EmptyElement)
    }

    @available(*, noasync)
    public func descendants(matching elementType: Element.ElementType) -> SyncQuery {
        Executor.execute {
            try SyncQuery(query: await self.query.descendants(matching: elementType))
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    public var any: SyncQuery {
        Executor.execute {
            try SyncQuery(query: await self.query.any)
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    public func children(matching type: Element.ElementType) -> SyncQuery {
        Executor.execute {
            try SyncQuery(query: await self.query.children(matching: type))
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    public func matching(_ predicate: NSPredicate) -> SyncQuery {
        let sendablebox = NSPredicateSendableBox(predicate: predicate)
        return Executor.execute {
            try SyncQuery(query: await self.query.matching(sendablebox.predicate))
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    public func matching(_ elementType: Element.ElementType, identifier: String?) -> SyncQuery {
        Executor.execute {
            try SyncQuery(query: await self.query.matching(elementType, identifier: identifier))
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    public func matching(identifier: String) -> SyncQuery {
        Executor.execute {
            try SyncQuery(query: await self.query.matching(identifier: identifier))
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    public func containing(_ predicate: NSPredicate) -> SyncQuery {
        let sendablebox = NSPredicateSendableBox(predicate: predicate)
        return Executor.execute {
            try SyncQuery(query: await self.query.containing(sendablebox.predicate))
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    public func containing(_ elementType: Element.ElementType, identifier: String?) -> SyncQuery {
        Executor.execute {
            try SyncQuery(query: await self.query.containing(elementType, identifier: identifier))
        }.valueOrFailWithFallback(.EmptyQuery)
    }

    @available(*, noasync)
    public var debugDescription: String {
        Executor.execute {
            try await self.query.debugDescription()
        }.valueOrFailWithFallback("")
    }
}
