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
}
