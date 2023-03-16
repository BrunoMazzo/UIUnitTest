//
//  File 2.swift
//
//
//  Created by Bruno Mazzo on 9/3/2023.
//

import Foundation

public class Query: ElementTypeQueryProvider {
    
    public var queryServerId: UUID?
    
    init(queryServerId: UUID) {
        self.queryServerId = queryServerId
    }
    
    init(queryRoot: UUID? = nil, elementType: Element.ElementType) async throws {
        let response: QueryResponse = try await callServer(path: "query", request: QueryRequest(queryRoot: queryRoot, elementType: elementType))
        self.queryServerId = response.serverId
    }
    
    deinit {
        let serverId = queryServerId!
        Task {
            let _: Bool = try await callServer(path: "remove", request: RemoveServerItemRequest(queryRoot: serverId))
        }
    }
    
    /** Returns an element that will use the query for resolution. */
    //    open var element: Element! {
    //        get async throws {
    //
    //        }
    //    }
    //
    
    /** Evaluates the query at the time it is called and returns the number of matches found. */
    public var count: Int {
        get async throws {
            let response: CountResponse = try await callServer(path: "count", request: CountRequest(serverId: self.queryServerId!))
            return response.count
        }
    }
    
    
    /** Returns an element that will resolve to the index into the query's result set. */
    //    open func element(atIndex index: Any!) -> Element!
    
    
    /** Returns an element that will use the index into the query's results to determine which underlying accessibility element it is matched with. */
    //    open func element(boundByIndex index: Any!) -> Element!
    
    
    /** Returns an element that matches the predicate. The predicate will be evaluated against objects of type id<XCUIElementAttributes>. */
    //    open func element(matchingPredicate predicate: Any!) -> Element!
    
    
    /** Returns an element that matches the type and identifier. */
    //    open func element(matchingType elementType: Any!, identifier: Any!) -> Element!
    
    
    /** Keyed subscripting is implemented as a shortcut for matching an identifier only. For example, app.descendants["Foo"] -> XCUIElement. */
    public subscript(_ identifier: String) -> Element {
        get async throws {
            let response: ElementResponse = try await callServer(path: "element", request: ElementRequest(queryRoot: queryServerId, identifier: identifier))
            return Element(serverId: response.serverId)
        }
    }
    
    
    /** Returns a new query that finds the descendants of all the elements found by the receiver. */
    //    open func descendants(matchingType type: Any!) -> Element!
    
    
    /** Returns a new query that finds the direct children of all the elements found by the receiver. */
    //    open func children(matchingType type: Any!) -> Element!
    
    
    /** Returns a new query that applies the specified attributes or predicate to the receiver. The predicate will be evaluated against objects of type id<XCUIElementAttributes>. */
    //    open func matchingPredicate(_ predicate: Any!) -> Element!
    
    //    open func matchingType(_ elementType: Any!, identifier: Any!) -> Element!
    
    //    open func matchingIdentifier(_ identifier: Any!) -> Element!
    
    
    /** Returns a new query for finding elements that contain a descendant matching the specification. The predicate will be evaluated against objects of type id<XCUIElementAttributes>. */
    //    open func containingPredicate(_ predicate: Any!) -> Element!
    
    //    open func containingType(_ elementType: Any!, identifier: Any!) -> Element!
}


public struct QueryRequest: Codable {
    
    public var queryRoot: UUID?
    public var elementType: Element.ElementType
    
    init(queryRoot: UUID? = nil, elementType: Element.ElementType) {
        self.queryRoot = queryRoot
        self.elementType = elementType
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
