import FlyingFox
import FlyingSocks
import Foundation
import UIUnitTestAPI
import XCTest

/// A global JSON decoder used for decoding incoming HTTP requests
let decoder = JSONDecoder()

/// A global JSON encoder used for encoding HTTP responses
let encoder = JSONEncoder()

/// The current version of the UIServer
let CurrentServerVersion = 6

/// A comprehensive HTTP server for remote UI testing of iOS applications using XCTest and XCUIApplication.
///
/// # Overview
/// `UIServer` provides a flexible, type-safe, and extensible framework for programmatically 
/// interacting with and testing user interfaces across iOS applications. It bridges the gap 
/// between automated testing tools and iOS applications by offering a robust, RESTful HTTP interface.
///
/// # Key Features
/// - **Application Lifecycle Management**
///   * Create and launch applications dynamically
///   * Activate specific app instances
///   * Manage multiple application contexts
///
/// - **Comprehensive Element Interaction**
///   * Advanced UI element querying and selection
///   * Gesture simulation (tap, swipe, pinch, rotate)
///   * Text input and value retrieval
///   * Scrolling and navigation
///
/// - **Accessibility and Inspection**
///   * Perform detailed accessibility audits
///   * Retrieve and validate element properties
///   * Check element states and accessibility
///
/// # Technical Architecture
/// ## Caching System
/// - Implements an intelligent caching mechanism for XCUIApplication and XCUIElement references
/// - Provides efficient, stateful lookup of UI elements across test sessions
/// - Minimizes resource overhead and improves test performance
///
/// ## Dynamic Routing
/// - Type-safe, dynamically registered HTTP routes
/// - JSON-based request/response communication
/// - Comprehensive error handling and logging
///
/// ## Concurrency and Thread Safety
/// - Fully `@MainActor` decorated to ensure thread-safe UI interactions
/// - Leverages Swift's async/await for non-blocking, responsive operations
///
/// # Use Cases
/// - Remote UI testing frameworks
/// - Automated UI test execution platforms
/// - Cross-platform testing tools
/// - Continuous integration and deployment (CI/CD) UI testing
///
/// # Performance and Security
/// - Minimal testing operation overhead
/// - Efficient element reference management
/// - Low-latency HTTP communication
/// - Secure loopback address execution
/// - Dynamic port assignment
/// - Support for multiple server instances
///
/// # Compatibility and Limitations
/// - Requires XCTest framework
/// - iOS platform specific
/// - Advanced features require iOS 17.0+
///
/// # Implementation Notes
/// The server uses a combination of dynamic routing, type-safe request handling, 
/// and a sophisticated caching mechanism to provide a comprehensive UI testing solution.
@MainActor
class UIServer {
    /// Stores the last XCTest issue encountered during server operations
    /// Useful for tracking and debugging test-related errors
    var lastIssue: XCTIssue?

    /// The underlying HTTP server that handles routing and request processing
    /// Manages the network communication for UI testing operations
    var server: HTTPServer!

    /// A cache mechanism to manage and track XCUIApplication and XCUIElement instances
    /// Provides efficient reference management and lookup for UI testing elements
    @MainActor
    let cache = Cache()

    /// Starts the UIServer with a specified port index
    ///
    /// This method sets up an HTTP server for UI testing operations, registering multiple routes
    /// for various UI interaction and querying capabilities. The server runs on a loopback address
    /// with a dynamically assigned port based on the provided port index.
    ///
    /// - Parameters:
    ///   - portIndex: An optional index to offset the base port number, allowing multiple server instances
    ///                Default value is 0, which means the server will start on the base port 22087
    /// - Throws: Errors related to server setup, route registration, or server startup
    func start(portIndex: UInt16 = 0) async throws {
        let server = HTTPServer(
            address: .loopback(port: 22087 + portIndex),
            logger: DisabledLogger.disabled
        )
        self.server = server

        // Register all routes using grouped methods
        await registerApplicationRoutes()
        await registerElementQueryRoutes()
        await registerInteractionRoutes()
        await registerElementStateRoutes()
        await registerElementInfoRoutes()
        await registerElementCollectionRoutes()
        await registerCoordinateRoutes()
        await registerAccessibilityRoutes()
        await registerUtilityRoutes()

        let task = Task { try await server.run() }

        try await server.waitUntilListening()

        print("Server ready")

        _ = await task.result
    }

    /// Adds a dynamically routed handler for processing HTTP requests with a specific type
    ///
    /// This method allows dynamic registration of routes with type-safe request and response handling.
    /// It provides a centralized mechanism for processing UI testing requests, including:
    /// - Decoding incoming JSON requests
    /// - Executing the provided handler
    /// - Building appropriate HTTP responses
    /// - Error handling for request processing
    ///
    /// - Parameters:
    ///   - route: The string route to register for handling requests
    ///   - handler: An asynchronous closure that processes the request and returns a typed response
    /// Dynamically registers a route with a type-safe request handler that returns a response
    ///
    /// This method allows for flexible and type-safe HTTP route registration for UI testing operations.
    /// It handles the entire request lifecycle, including:
    /// - JSON decoding of the incoming request
    /// - Executing the provided handler
    /// - Building an appropriate HTTP response
    /// - Error handling and logging
    ///
    /// - Parameters:
    ///   - route: A string representing the HTTP route to register
    ///   - handler: An asynchronous closure that processes the request and returns a typed response
    /// - Note: Automatically resets `lastIssue` before processing each request
    func addRoute<Request: Codable, Response: Codable>(_ route: String, handler: @escaping @MainActor (Request) async throws -> Response) async {
        await server.appendRoute(HTTPRoute(stringLiteral: route), handler: { @MainActor request in

            defer {
                self.lastIssue = nil
            }

            let tapRequest = try await decoder.decode(Request.self, from: request.bodyData)

            do {
                let response = try await handler(tapRequest)
                return self.buildResponse(response)
            } catch {
                return self.buildError(error.localizedDescription)
            }
        })
    }

    /// Dynamically registers a route with a type-safe request handler that does not return a response
    ///
    /// This overload of `addRoute` is used for handlers that perform an action without returning a value.
    /// It wraps the void handler to return a boolean success indicator.
    ///
    /// - Parameters:
    ///   - route: A string representing the HTTP route to register
    ///   - handler: An asynchronous closure that processes the request without returning a value
    /// - Note: Converts the void handler to return `true` on successful completion
    func addRoute<Request: Codable>(_ route: String, handler: @escaping @MainActor (Request) async throws -> Void) async {
        await addRoute(route, handler: { request in
            try await handler(request)
            return true
        })
    }

    /// Creates a new XCUIApplication instance for a given bundle identifier
    ///
    /// This method instantiates an XCUIApplication with the specified bundle identifier,
    /// adds it to the server's cache for tracking, and optionally activates the application.
    ///
    /// - Parameters:
    ///   - request: A request containing the bundle identifier and optional activation flag
    ///   - Throws: Errors related to application creation or caching
    @MainActor
    func createApp(request: CreateApplicationRequest) async throws {
        let app = XCUIApplication(bundleIdentifier: request.appId)
        cache.add(application: app, id: request.serverId)

        if request.activate {
            app.activate()
        }
    }

    /// Activates a previously created XCUIApplication instance
    ///
    /// This method retrieves an application from the server's cache and activates it,
    /// bringing it to the foreground and making it the active application.
    ///
    /// - Parameters:
    ///   - activateRequest: A request containing the server ID of the application to activate
    /// - Throws: Errors related to application retrieval or activation
    @MainActor
    func activate(_ activateRequest: ActivateRequest) async throws {
        let app = try cache.getApplication(activateRequest.serverId)
        app.activate()
    }

    /// Performs an accessibility audit on the specified application
    ///
    /// This method runs an accessibility audit on the given application, checking for
    /// potential accessibility issues based on the specified audit type. It is only 
    /// available on iOS 17.0 and later.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the application and the type of accessibility audit to perform
    /// - Returns: An `AccessibilityAuditResponse` containing any identified accessibility issues
    /// - Throws: 
    ///   - Errors if the application cannot be retrieved from the cache
    ///   - An error for iOS versions earlier than 17.0
    @MainActor
    func performAccessibilityAudit(
        request: AccessibilityAuditRequest
    ) async throws -> AccessibilityAuditResponse {
        let app = try cache.getApplication(request.serverId)

        if #available(iOS 17.0, *) {
            var issues = [XCUIAccessibilityAuditIssue]()
            try app.performAccessibilityAudit(for: request.accessibilityAuditType.toXCUIAccessibilityAuditType()) { issue in
                issues.append(issue)
                return true
            }

            var issuesData: [AccessibilityAuditIssueData] = []
            for issue in issues {
                issuesData.append(AccessibilityAuditIssueData(xcIssue: issue, cache: cache))
            }

            return AccessibilityAuditResponse(issues: issuesData)
        } else {
            // Fallback on earlier versions
            throw NSError(domain: "com.apple.XCTest", code: 0, userInfo: nil)
        }
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
    @MainActor
    func firstMatch(firstMatchRequest: FirstMatchRequest) async throws -> FirstMatchResponse {
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
    @MainActor
    func elementFromQuery(elementFromQuery: ElementFromQuery) async throws -> ElementPayload {
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
    @MainActor
    func elementMatchingPredicate(predicateRequest: PredicateRequest) async throws -> ElementPayload {
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
    @MainActor
    func matchingPredicate(predicateRequest: PredicateRequest) async throws -> QueryResponse {
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
    @MainActor
    func matchingByIdentifier(request: ByIdRequest) async throws -> QueryResponse {
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
    @MainActor
    func containingPredicate(request: PredicateRequest) async throws -> QueryResponse {
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
    @MainActor
    func containingElementType(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootQuery = try cache.getElementQuery(request.serverId)
        let query = rootQuery.containing(request.elementType.toXCUIElementType(), identifier: request.identifier)

        let id = cache.add(query: query)

        return QueryResponse(serverId: id)
    }

    /// Types text into a specific UI element
    ///
    /// This method simulates typing text into a UI element such as a text field or text view.
    /// It uses the XCUIElement's `typeText` method to enter the specified text.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element and the text to enter
    /// - Throws: Errors related to element retrieval or text entry
    @MainActor
    func typeText(request: EnterTextRequest) async throws {
        let element = try cache.getElement(request.serverId)
        element.typeText(request.textToEnter)
    }

    /// Retrieves the current value of a UI element
    ///
    /// This method fetches the value of an element, typically used for text fields, 
    /// sliders, or other elements that have a value property. It returns the value as a string.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element to retrieve the value from
    /// - Returns: A `ValueResponse` containing the element's value as a string, or nil if no value
    /// - Throws: Errors related to element retrieval
    @MainActor
    func value(request: ElementPayload) async throws -> ValueResponse {
        let element = try cache.getElement(request.serverId)
        let value = element.value as? String

        return ValueResponse(value: value)
    }

    /// Scrolls a UI element by specified horizontal and vertical deltas
    ///
    /// This method simulates scrolling an element by a given amount in X and Y directions.
    /// Useful for scrolling lists, tables, or scrollable containers.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element to scroll and the scroll deltas
    /// - Throws: Errors related to element retrieval or scrolling
    @MainActor
    func scroll(request: ScrollRequest) async throws {
        let element = try cache.getElement(request.serverId)
        element.scroll(byDeltaX: request.deltaX, deltaY: request.deltaY)
    }

    /// Performs a swipe gesture on a UI element in a specified direction
    ///
    /// This method simulates a swipe interaction with a UI element, allowing swipes in four directions:
    /// left, right, up, or down. The swipe can be performed with a specified velocity.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element, swipe direction, and velocity
    /// - Throws: Errors related to element retrieval or swipe gesture
    @MainActor
    func swipe(request: SwipeRequest) async throws {
        let element = try cache.getElement(request.serverId)

        let velocity = request.velocity.xcUIGestureVelocity

        switch request.swipeDirection {
        case .left:
            element.swipeLeft(velocity: velocity)
        case .right:
            element.swipeRight(velocity: velocity)
        case .up:
            element.swipeUp(velocity: velocity)
        case .down:
            element.swipeDown(velocity: velocity)
        }
    }

    /// Performs a pinch gesture on a UI element
    ///
    /// This method simulates a pinch interaction, typically used for zooming in or out.
    /// The pinch is defined by a scale factor and velocity.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element, scale of the pinch, and velocity
    /// - Throws: Errors related to element retrieval or pinch gesture
    @MainActor
    func pinch(request: PinchRequest) async throws {
        let element = try cache.getElement(request.serverId)
        element.pinch(withScale: request.scale, velocity: request.velocity)
    }

    /// Performs a rotation gesture on a UI element
    ///
    /// This method simulates a rotation interaction, typically used for rotating views or images.
    /// The rotation is defined by a rotation angle and velocity.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element, rotation angle, and velocity
    /// - Throws: Errors related to element retrieval or rotation gesture
    @MainActor
    func rotate(request: RotateRequest) async throws {
        let element = try cache.getElement(request.serverId)
        element.rotate(request.rotation, withVelocity: request.velocity)
    }

    /// Checks if a UI element is hittable
    ///
    /// This method determines whether a specific UI element can be interacted with 
    /// (i.e., tapped or clicked) at its current location and state.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the element to check
    /// - Returns: An `IsHittableResponse` indicating whether the element is hittable
    /// - Throws: Errors related to element retrieval
    @MainActor
    func isHittable(request: ElementPayload) async throws -> IsHittableResponse {
        let isHittable = try cache.getElement(request.serverId).isHittable
        return IsHittableResponse(isHittable: isHittable)
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
    func element(request: ByIdRequest) async throws -> ElementPayload {
        let newElement = try await findElement(elementRequest: request)
        let id = cache.add(element: newElement)
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

    /// Performs an accessibility audit on an application
    ///
    /// This method attempts to run an accessibility audit on the specified application.
    /// It is only available on iOS 17.0 and later versions.
    ///
    /// - Parameters:
    ///   - request: Contains the server ID of the application to audit
    /// - Returns: A boolean indicating whether the accessibility audit was successful
    /// - Throws: Errors related to application retrieval or accessibility audit
    @MainActor
    func accessibilityTest(request: ElementPayload) async throws -> Bool {
        let application = try cache.getApplication(request.serverId)

        if #available(iOS 17.0, *) {
            return (try? application.performAccessibilityAudit()) != nil
        } else {
            return false
        }
    }

    func buildResponse(_ data: some Codable) -> HTTPResponse {
        if let lastIssue {
            return buildError(lastIssue.detailedDescription ?? lastIssue.description)
        } else {
            return HTTPResponse(statusCode: .ok, body: try! encoder.encode(UIResponse(response: data)))
        }
    }

    func buildError(_ error: String) -> HTTPResponse {
        return HTTPResponse(statusCode: .badRequest, body: try! encoder.encode(UIResponse<Bool>(error: error)))
    }

    func findElement(elementRequest: ByIdRequest) async throws -> XCUIElement {
        let rootElementQuery = try cache.getElementQuery(elementRequest.queryRoot)

        return rootElementQuery[elementRequest.identifier]
    }

}

public extension UInt {
    func toXCUIElementType() -> XCUIElement.ElementType {
        XCUIElement.ElementType(rawValue: self)!
    }
}

extension UInt64 {
    @available(iOS 17.0, *)
    func toXCUIAccessibilityAuditType() -> XCUIAccessibilityAuditType {
        return XCUIAccessibilityAuditType(rawValue: self)
    }
}

extension AccessibilityAuditIssueData {
    @available(iOS 17.0, *)
    @MainActor
    init(xcIssue: XCUIAccessibilityAuditIssue, cache: Cache) {
        var elementId: UUID?
        if let element = xcIssue.element {
            elementId = cache.add(element: element)
        }
        self.init(
            element: elementId,
            compactDescription: xcIssue.compactDescription,
            detailedDescription: xcIssue.detailedDescription,
            auditType: xcIssue.auditType.rawValue
        )
    }
}

extension UIServer {
    @MainActor
    func performQuery(queryRequest: QueryRequest) async throws -> XCUIElementQuery {
        let rootElementQuery = try cache.getQuery(queryRequest.serverId)
        return rootElementQuery.queryBy(queryRequest.queryType)
    }
}
