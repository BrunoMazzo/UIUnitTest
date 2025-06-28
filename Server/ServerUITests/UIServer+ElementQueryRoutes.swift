import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Element Query Routes
extension UIServer {
    /// Registers routes for element querying and selection
    /// - firstMatch: Gets the first matching element from a query
    /// - elementFromQuery: Retrieves a specific element from a query
    /// - elementMatchingPredicate: Gets element matching a predicate
    /// - matchingPredicate: Creates query with elements matching predicate
    /// - matchingByIdentifier: Creates query with elements matching identifier
    /// - containingPredicate: Creates query containing elements matching predicate
    /// - containingElementType: Creates query containing elements of specific type
    func registerElementQueryRoutes() async {
        await addRoute("firstMatch", handler: firstMatch(firstMatchRequest:))
        await addRoute("elementFromQuery", handler: elementFromQuery(elementFromQuery:))
        await addRoute("elementMatchingPredicate", handler: elementMatchingPredicate(predicateRequest:))
        await addRoute("matchingPredicate", handler: matchingPredicate(predicateRequest:))
        await addRoute("matchingByIdentifier", handler: matchingByIdentifier(request:))
        await addRoute("containingPredicate", handler: containingPredicate(request:))
        await addRoute("containingElementType", handler: containingElementType(request:))
    }
}
