import FlyingFox
import Foundation
import UIUnitTestAPI
import XCTest

// MARK: - Accessibility Routes
extension UIServer {
    /// Registers routes for accessibility operations
    /// - performAccessibilityAudit: Performs accessibility audit
    func registerAccessibilityRoutes() async {
        await addRoute("performAccessibilityAudit", handler: performAccessibilityAudit(request:))
    }
}
