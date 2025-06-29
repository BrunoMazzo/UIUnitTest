import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Application Routes
extension UIServer {
    /// Registers routes for application lifecycle management
    /// - createApp: Creates a new XCUIApplication instance
    /// - Activate: Activates a previously created application
    func registerApplicationRoutes() async {
        await addRoute("createApp", handler: createApp(request:))
        await addRoute("Activate", handler: activate(_:))
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
}
