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

        // Register all route groups
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
