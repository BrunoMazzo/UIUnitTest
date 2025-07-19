import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

/// A class responsible for handling application lifecycle management routes
@MainActor
final class ApplicationRoutes {
    private let cache: ServerState
    private let routeRegistrar: RouteRegistering
    
    /// Initializes a new ApplicationRoutes instance
    /// - Parameters:
    ///   - cache: The server state cache for managing application instances
    ///   - routeRegistrar: The object responsible for registering routes
    init(cache: ServerState, routeRegistrar: RouteRegistering) {
        self.cache = cache
        self.routeRegistrar = routeRegistrar
    }
    
    /// Registers routes for application lifecycle management
    /// - createApp: Creates a new XCUIApplication instance
    /// - Activate: Activates a previously created application
    func registerRoutes() async {
        await routeRegistrar.addRoute("createApp", handler: createApp(request:))
        await routeRegistrar.addRoute("Activate", handler: activate(_:))
    }

    /// Creates a new XCUIApplication instance for a given bundle identifier
    ///
    /// This method instantiates an XCUIApplication with the specified bundle identifier,
    /// adds it to the server's cache for tracking, and optionally activates the application.
    ///
    /// - Parameters:
    ///   - request: A request containing the bundle identifier and optional activation flag
    /// - Throws: Errors related to application creation or caching
    private func createApp(request: CreateApplicationRequest) async throws {
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
    private func activate(_ activateRequest: ActivateRequest) async throws {
        let app = try cache.getApplication(activateRequest.serverId)
        app.activate()
    }
}

/// Protocol defining the interface for route registration
@MainActor
protocol RouteRegistering {
    func addRoute<Request: Codable, Response: Codable>(_ route: String, handler: @escaping @MainActor (Request) async throws -> Response) async
    func addRoute<Request: Codable>(_ route: String, handler: @escaping @MainActor (Request) async throws -> Void) async
}

// MARK: - UIServer + RouteRegistering
extension UIServer: RouteRegistering {}

// MARK: - UIServer + Application Routes
extension UIServer {
    /// Registers routes for application lifecycle management
    func registerApplicationRoutes() async {
        let routes = ApplicationRoutes(cache: cache, routeRegistrar: self)
        await routes.registerRoutes()
    }
}
