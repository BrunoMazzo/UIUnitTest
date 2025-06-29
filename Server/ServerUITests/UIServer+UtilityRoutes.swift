import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Utility Routes
extension UIServer {
    /// Registers utility routes for server management
    /// - stop: Stops the server
    /// - alive: Health check endpoint
    /// - server-version: Gets server version
    func registerUtilityRoutes() async {
        await self.server.appendRoute(HTTPRoute(stringLiteral: "stop"), to: ClosureHTTPHandler { _ in
            Task {
                await self.server.stop(timeout: 10)
            }

            return await self.buildResponse(true)
        })

        await self.server.appendRoute(HTTPRoute(stringLiteral: "alive"), to: ClosureHTTPHandler { _ in
            await self.buildResponse(true)
        })

        await self.server.appendRoute(HTTPRoute(stringLiteral: "server-version"), to: ClosureHTTPHandler { _ in
            await self.buildResponse(CurrentServerVersion)
        })
    }

    /// Builds an HTTP response with JSON-encoded data
    ///
    /// This method takes any encodable data and returns an HTTP response with the
    /// data encoded as JSON. It's used internally by route handlers to format
    /// their responses consistently.
    ///
    /// - Parameters:
    ///   - data: The data to encode in the response
    /// - Returns: An HTTP response containing the JSON-encoded data
    /// - Throws: Errors related to JSON encoding
    func buildResponse<T: Encodable>(_ data: T) async throws -> HTTPResponse {
        let jsonData = try JSONEncoder().encode(data)
        return HTTPResponse(body: .data(jsonData))
    }

    /// Finds an element based on a request
    ///
    /// This method searches for an element using the criteria specified in the request.
    /// It supports finding elements by identifier and other attributes.
    ///
    /// - Parameters:
    ///   - elementRequest: Contains the search criteria for finding the element
    /// - Returns: The found XCUIElement
    /// - Throws: Errors if the element cannot be found or if the search criteria are invalid
    func findElement(elementRequest: ByIdRequest) async throws -> XCUIElement {
        let rootQuery = try cache.getElementQuery(elementRequest.queryRoot)
        return rootQuery.element(matching: elementRequest.identifier)
    }

    /// Performs a query based on a request
    ///
    /// This method executes a query on the UI hierarchy based on the specified criteria.
    /// It supports various query types and filtering options.
    ///
    /// - Parameters:
    ///   - queryRequest: Contains the query parameters and type
    /// - Returns: The resulting XCUIElementQuery
    /// - Throws: Errors if the query cannot be executed or if the parameters are invalid
    func performQuery(queryRequest: QueryRequest) async throws -> XCUIElementQuery {
        let rootQuery = try cache.getElementQuery(queryRequest.queryRoot)

        switch queryRequest.type {
        case .all:
            return rootQuery
        case let .matching(identifier):
            return rootQuery.matching(identifier: identifier)
        case let .matchingPredicate(predicate):
            return rootQuery.matching(predicate)
        case let .matchingType(elementType):
            return rootQuery.matching(elementType.toXCUIElementType())
        case let .matchingTypeAndIdentifier(elementType, identifier):
            return rootQuery.matching(elementType.toXCUIElementType(), identifier: identifier)
        }
    }
}
