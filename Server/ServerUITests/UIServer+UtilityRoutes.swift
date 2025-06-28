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
}
