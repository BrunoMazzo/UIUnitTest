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
}
