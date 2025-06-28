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
}
