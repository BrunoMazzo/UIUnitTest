import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Element Collection Routes
extension UIServer {
    /// Registers routes for element collection operations
    /// - count: Gets count of elements in query
    /// - queryDescendants: Gets descendants query from query
    /// - elementDescendants: Gets descendants query from element
    /// - matchingElementType: Creates query matching element type
    /// - allElementsBoundByAccessibilityElement: Gets all elements bound by accessibility
    /// - allElementsBoundByIndex: Gets all elements bound by index
    /// - children: Gets children matching type
    /// - query: Performs custom query
    /// - element: Gets specific element by identifier
    /// - remove: Removes element from cache
    /// - debugDescription: Gets debug description
    func registerElementCollectionRoutes() async {
        await addRoute("count", handler: count(request:))
        await addRoute("queryDescendants", handler: queryDescendants(request:))
        await addRoute("elementDescendants", handler: elementDescendants(request:))
        await addRoute("matchingElementType", handler: matchingElementType(request:))
        await addRoute("allElementsBoundByAccessibilityElement", handler: allElementsBoundByAccessibilityElement(request:))
        await addRoute("allElementsBoundByIndex", handler: allElementsBoundByIndex(request:))
        await addRoute("children", handler: children(request:))
        await addRoute("query", handler: query(request:))
        await addRoute("element", handler: element(request:))
        await addRoute("remove", handler: remove(request:))
        await addRoute("debugDescription", handler: debugDescription(request:))
    }

    /// Counts the number of elements in a query
    ///
    /// This method returns the total number of elements that match a specific query.
    /// Useful for verifying the number of elements found by a particular query.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the query to count
    /// - Returns: A `CountResponse` with the number of elements in the query
    /// - Throws: Errors related to query retrieval
    @MainActor
    func count(request: CountRequest) async throws -> CountResponse {
        let count: Int = try (cache.getElementQuery(request.serverId)).count
        return CountResponse(count: count)
    }

    /// Retrieves descendants of a query matching a specific element type
    ///
    /// This method finds all descendant elements of a query that match a given element type.
    /// The resulting query is cached for further manipulation or querying.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the source query and the element type to match
    /// - Returns: A `QueryResponse` with the server ID of the new descendants query
    /// - Throws: Errors related to query retrieval or element type matching
    @MainActor
    func queryDescendants(request: DescendantsFromQuery) async throws -> QueryResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let descendantsQuery = rootQuery.descendants(matching: request.elementType.toXCUIElementType())

        let id = cache.add(query: descendantsQuery)

        return QueryResponse(serverId: id)
    }

    /// Retrieves descendants of an element matching a specific element type
    ///
    /// This method finds all descendant elements of a specific element that match a given element type.
    /// The resulting query is cached for further manipulation or querying.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the source element and the element type to match
    /// - Returns: A `QueryResponse` with the server ID of the new descendants query
    /// - Throws: Errors related to element retrieval or element type matching
    @MainActor
    func elementDescendants(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootElement = try cache.getElement(request.serverId)
        let descendantsQuery = rootElement.descendants(matching: request.elementType.toXCUIElementType())

        let id = cache.add(query: descendantsQuery)

        return QueryResponse(serverId: id)
    }

    /// Creates a new query containing elements of a specific type
    ///
    /// This method filters an existing element query to create a new query containing
    /// only the elements that match a specified type and optional identifier.
    ///
    /// - Parameters:
    ///   - request: Contains the source query's server ID, element type, and optional identifier
    /// - Returns: A `QueryResponse` with the server ID of the new filtered query
    /// - Throws: Errors related to query retrieval or element type matching
    @MainActor
    func matchingElementType(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let descendantsQuery = rootQuery.matching(request.elementType.toXCUIElementType(), identifier: request.identifier)
        let id = cache.add(query: descendantsQuery)
        return QueryResponse(serverId: id)
    }

    /// Retrieves all elements bound by their accessibility element
    ///
    /// This method returns all elements from a query that are grouped by their accessibility element.
    /// The elements are added to the server's cache and their server IDs are returned.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the source query
    /// - Returns: An `ElementArrayResponse` with server IDs of the retrieved elements
    /// - Throws: Errors related to query retrieval
    @MainActor
    func allElementsBoundByAccessibilityElement(request: ElementsByAccessibility) async throws -> ElementArrayResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let allElements = rootQuery.allElementsBoundByAccessibilityElement

        let ids = cache.add(elements: allElements)

        return ElementArrayResponse(serversId: ids)
    }

    /// Retrieves all elements bound by their index
    ///
    /// This method returns all elements from a query that are grouped by their index.
    /// The elements are added to the server's cache and their server IDs are returned.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the source query
    /// - Returns: An `ElementArrayResponse` with server IDs of the retrieved elements
    /// - Throws: Errors related to query retrieval
    @MainActor
    func allElementsBoundByIndex(request: ElementsByAccessibility) async throws -> ElementArrayResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let allElements = rootQuery.allElementsBoundByIndex

        let ids = cache.add(elements: allElements)

        return ElementArrayResponse(serversId: ids)
    }

    /// Retrieves child elements matching a specific type
    ///
    /// This method finds child elements of a query or element that match a given element type.
    /// It supports retrieving children from both element queries and individual elements.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the source query/element and the element type to match
    /// - Returns: A `QueryResponse` with the server ID of the new children query
    /// - Throws: Errors if the source element or query cannot be found
    @MainActor
    func children(request: ChildrenMatchinType) async throws -> QueryResponse {
        var childrenQuery: XCUIElementQuery

        if let rootQuery = try? cache.getElementQuery(request.serverId) {
            childrenQuery = rootQuery.children(matching: request.elementType.toXCUIElementType())
        } else if let rootElement = try? cache.getElement(request.serverId) {
            childrenQuery = rootElement.children(matching: request.elementType.toXCUIElementType())
        } else {
            throw ElementNotFoundError(serverId: request.serverId.uuidString)
        }

        let id = cache.add(query: childrenQuery)

        return QueryResponse(serverId: id)
    }

    /// Retrieves a specific element by its identifier from a query
    ///
    /// This method finds an element within a query using the provided identifier.
    /// The found element is added to the server's cache and its server ID is returned.
    ///
    /// - Parameters:
    ///   - request: Contains the query's server ID and the identifier of the element to find
    /// - Returns: An `ElementPayload` with the server ID of the found element
    /// - Throws: Errors related to query retrieval or element matching
    @MainActor
    func element(request: ByIdRequest) async -> ElementPayload {
        let rootElementQuery =  try! self.cache.getElementQuery(request.queryRoot)
        let newElement =  rootElementQuery[request.identifier]
        let id = self.cache.add(element: newElement)
        return ElementPayload(serverId: id)
    }

    /// Performs a custom query on an existing query
    ///
    /// This method allows executing a custom query on a previously cached query,
    /// providing flexibility in element selection and filtering.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the source query and the query type to apply
    /// - Returns: A `QueryResponse` with the server ID of the new query
    /// - Throws: Errors related to query retrieval or query execution
    @MainActor
    func query(request: QueryRequest) async throws -> QueryResponse {
        let newQuery = try await performQuery(queryRequest: request)
        let serverId = cache.add(query: newQuery)
        return QueryResponse(serverId: serverId)
    }

    /// Removes an element from the server's cache
    ///
    /// This method deletes a specific element from the server's internal cache,
    /// freeing up resources and removing the reference to the element.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element to remove
    /// - Returns: A boolean indicating whether the removal was successful
    @MainActor
    func remove(request: ElementPayload) async -> Bool {
        cache.remove(request.serverId)

        return true
    }
}
