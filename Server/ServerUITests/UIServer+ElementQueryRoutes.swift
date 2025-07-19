import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

/// A class responsible for handling element query routes
@MainActor
final class ElementQueryRoutes {
    private let cache: ServerState
    private let routeRegistrar: RouteRegistering
    
    /// Initializes a new ElementQueryRoutes instance
    /// - Parameters:
    ///   - cache: The server state cache for managing application instances
    ///   - routeRegistrar: The object responsible for registering routes
    init(cache: ServerState, routeRegistrar: RouteRegistering) {
        self.cache = cache
        self.routeRegistrar = routeRegistrar
    }
    
    /// Registers routes for element querying and selection
    /// - firstMatch: Gets the first matching element from a query
    /// - elementFromQuery: Retrieves a specific element from a query
    /// - elementMatchingPredicate: Gets element matching a predicate
    /// - matchingPredicate: Creates query with elements matching predicate
    /// - matchingByIdentifier: Creates query with elements matching identifier
    /// - containingPredicate: Creates query containing elements matching predicate
    /// - containingElementType: Creates query containing elements of specific type
    func registerRoutes() async {
        await routeRegistrar.addRoute("firstMatch", handler: firstMatch(firstMatchRequest:))
        await routeRegistrar.addRoute("elementFromQuery", handler: elementFromQuery(elementFromQuery:))
        await routeRegistrar.addRoute("elementMatchingPredicate", handler: elementMatchingPredicate(predicateRequest:))
        await routeRegistrar.addRoute("matchingPredicate", handler: matchingPredicate(predicateRequest:))
        await routeRegistrar.addRoute("matchingByIdentifier", handler: matchingByIdentifier(request:))
        await routeRegistrar.addRoute("containingPredicate", handler: containingPredicate(request:))
        await routeRegistrar.addRoute("containingElementType", handler: containingElementType(request:))
    }

    /// Retrieves the first matching element from a given query
    ///
    /// This method finds the first element that matches the specified query 
    /// and adds it to the server's cache for further manipulation.
    ///
    /// - Parameters:
    ///   - firstMatchRequest: A request containing the server ID of the query to match
    /// - Returns: A response with the server ID of the first matching element
    /// - Throws: Errors related to query retrieval or element matching
    private func firstMatch(firstMatchRequest: FirstMatchRequest) async throws -> FirstMatchResponse {
        let query = try cache.getQuery(firstMatchRequest.serverId)
        let element = query.firstMatch

        let id = cache.add(element: element)

        return FirstMatchResponse(serverId: id)
    }

    /// Retrieves a specific element from a query based on various criteria
    ///
    /// This method allows retrieving an element from a query using different selection methods:
    /// - By index: Select an element at a specific position in the query
    /// - By element type and optional identifier: Select an element matching a specific type
    /// - Default: Select the first element in the query
    ///
    /// - Parameters:
    ///   - elementFromQuery: A request containing the query server ID and optional selection criteria
    /// - Returns: A payload containing the server ID of the selected element
    /// - Throws: Errors related to query retrieval or element selection
    private func elementFromQuery(elementFromQuery: ElementFromQuery) async throws -> ElementPayload {
        let query = try cache.getElementQuery(elementFromQuery.serverId)

        let element: XCUIElement
        if let index = elementFromQuery.index {
            element = query.element(boundBy: index)
        } else if let type = elementFromQuery.elementType {
            element = query.element(matching: type.toXCUIElementType(), identifier: elementFromQuery.identifier)
        } else {
            element = query.element
        }

        let id = cache.add(element: element)

        return ElementPayload(serverId: id)
    }

    /// Retrieves an element from a query that matches a specific predicate
    ///
    /// This method finds the first element in a query that satisfies the given predicate
    /// and adds it to the server's cache for further manipulation.
    ///
    /// - Parameters:
    ///   - predicateRequest: A request containing the query server ID and the predicate to match
    /// - Returns: A payload containing the server ID of the matching element
    /// - Throws: Errors related to query retrieval or element matching
    private func elementMatchingPredicate(predicateRequest: PredicateRequest) async throws -> ElementPayload {
        let query = try cache.getElementQuery(predicateRequest.serverId)

        let element = query.element(matching: predicateRequest.predicate)

        let id = cache.add(element: element)

        return ElementPayload(serverId: id)
    }

    /// Retrieves a new query containing elements that match the specified predicate
    ///
    /// This method filters an existing element query to create a new query containing
    /// only the elements that satisfy the given predicate. The resulting query is 
    /// cached for further manipulation or querying.
    ///
    /// - Parameters:
    ///   - predicateRequest: A request containing the source query's server ID and the predicate to match
    /// - Returns: A response with the server ID of the new filtered query
    /// - Throws: Errors related to query retrieval or predicate matching
    private func matchingPredicate(predicateRequest: PredicateRequest) async throws -> QueryResponse {
        let query = try cache.getElementQuery(predicateRequest.serverId)
        let matching = query.matching(predicateRequest.predicate)
        let id = cache.add(query: matching)
        return QueryResponse(serverId: id)
    }

    /// Retrieves a new query containing elements with a specific identifier
    ///
    /// This method creates a new query that contains all elements from the root query
    /// that match the given identifier. The resulting query is cached for further use.
    ///
    /// - Parameters:
    ///   - request: A request containing the root query's server ID and the identifier to match
    /// - Returns: A response with the server ID of the new filtered query
    /// - Throws: Errors related to query retrieval or identifier matching
    private func matchingByIdentifier(request: ByIdRequest) async throws -> QueryResponse {
        let query = try cache.getElementQuery(request.queryRoot)
        let matching = query.matching(identifier: request.identifier)
        let id = cache.add(query: matching)
        return QueryResponse(serverId: id)
    }

    /// Creates a new query containing elements that include a specific predicate
    ///
    /// This method filters an existing element query to create a new query containing
    /// only the elements that contain (include) elements matching the given predicate.
    /// The resulting query is cached for further manipulation or querying.
    ///
    /// - Parameters:
    ///   - request: A request containing the source query's server ID and the predicate to match
    /// - Returns: A response with the server ID of the new filtered query
    /// - Throws: Errors related to query retrieval or predicate matching
    private func containingPredicate(request: PredicateRequest) async throws -> QueryResponse {
        let query = try cache.getElementQuery(request.serverId)
        let matching = query.containing(request.predicate)
        let id = cache.add(query: matching)
        return QueryResponse(serverId: id)
    }

    /// Creates a new query containing elements of a specific type
    ///
    /// This method filters an existing element query to create a new query containing
    /// only the elements of a specified type and optional identifier. The resulting 
    /// query is cached for further manipulation or querying.
    ///
    /// - Parameters:
    ///   - request: A request containing the source query's server ID, element type, and optional identifier
    /// - Returns: A response with the server ID of the new filtered query
    /// - Throws: Errors related to query retrieval or element type matching
    private func containingElementType(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let query = rootQuery.containing(request.elementType.toXCUIElementType(), identifier: request.identifier)

        let id = cache.add(query: query)

        return QueryResponse(serverId: id)
    }
}

// MARK: - UIServer + Element Query Routes
extension UIServer {
    /// Registers routes for element querying and selection
    func registerElementQueryRoutes() async {
        let routes = ElementQueryRoutes(cache: cache, routeRegistrar: self)
        await routes.registerRoutes()
    }
}
