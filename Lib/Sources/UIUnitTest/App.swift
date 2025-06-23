import Foundation
import UIUnitTestAPI
import XCTest

/// Creates a synchronous API instance for UI testing.
///
/// - Returns: A `SyncApi` instance ready for use in UI testing.
/// - Note: This is a non-async version of the App initializer.
@available(*, noasync)
public func App() -> SyncApi {
    return SyncApi()
}

/// Creates an asynchronous API instance for UI testing.
///
/// - Returns: An `AsyncApi` instance ready for use in UI testing.
/// - Throws: Any error that occurs during API initialization.
public func App() async throws -> AsyncApi {
    return try await AsyncApi()
}

/// Represents an asynchronous API for UI testing, providing methods to interact with and manage application state.
///
/// This class provides async methods for creating, activating, and interacting with an application during UI testing.
/// It supports both iOS 17+ accessibility audits and general app interaction methods.
///
/// - Note: This class is thread-safe and can be used concurrently.
public class AsyncApi: Element, @unchecked Sendable {
    /// The unique identifier for the application being tested.
    let appId: String

    /// Provides a synchronous API interface for this asynchronous API instance.
    ///
    /// - Returns: A `SyncApi` wrapping the current `AsyncApi` instance.
    public var syncAPI: SyncApi { SyncApi(asyncApi: self) }

    /// Initializes an `AsyncApi` instance for a specific application.
    ///
    /// - Parameters:
    ///   - appId: The bundle identifier of the application to test. Defaults to the main bundle identifier.
    ///   - activate: A boolean indicating whether to activate the application immediately. Defaults to `true`.
    /// - Throws: An error if the application creation fails.
    public init(appId: String = Bundle.main.bundleIdentifier!, activate: Bool = true) async throws {
        self.appId = appId
        super.init(serverId: UUID())

        try await create(activate: activate)
    }

    /// Initializes a non-async `AsyncApi` instance for a specific application.
    ///
    /// - Parameters:
    ///   - appId: The bundle identifier of the application to test. Defaults to the main bundle identifier.
    ///   - activate: A boolean indicating whether to activate the application immediately. Defaults to `true`.
    @available(*, noasync)
    public init(appId: String = Bundle.main.bundleIdentifier!, activate: Bool = true) {
        self.appId = appId
        super.init(serverId: UUID())

        create(activate: activate)
    }

    /// A required initializer that is not implemented.
    ///
    /// - Throws: A fatal error indicating that this initializer is not supported.
    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    /// Simulates pressing the home button on the device.
    ///
    /// - Throws: An error if the home button press fails.
    public func pressHomeButton() async throws {
        let _: Bool = try await callServer(path: "HomeButton", request: HomeButtonRequest())
    }

    /// A non-async version of `pressHomeButton()`.
    ///
    /// - Note: This method uses an executor to handle the async operation.
    @available(*, noasync)
    public func pressHomeButton() {
        Executor.execute {
            try await self.pressHomeButton()
        }.valueOrFailWithFallback(())
    }

    /// Activates the application.
    ///
    /// - Throws: An error if the activation fails.
    public func activate() async throws {
        let activateRequestData = ActivateRequest(serverId: serverId)

        let _: Bool = try await callServer(path: "Activate", request: activateRequestData)
    }

    /// A non-async version of `activate()`.
    ///
    /// - Note: This method uses an executor to handle the async operation.
    @available(*, noasync)
    public func activate() {
        Executor.execute {
            try await self.activate()
        }.valueOrFailWithFallback(())
    }

    /// Creates and sets up the application for testing.
    ///
    /// - Parameters:
    ///   - activate: A boolean indicating whether to activate the application immediately.
    ///   - timeout: The maximum time to wait for application creation. Defaults to 30 seconds.
    /// - Throws: An error if the application cannot be created within the specified timeout.
    public func create(activate: Bool, timeout: TimeInterval = 30_000_000_000) async throws {
        let start = Date()

        while abs(start.timeIntervalSinceNow) < timeout {
            let request = CreateApplicationRequest(appId: appId, serverId: serverId, activate: activate)

            let success: Bool = (try? await callServer(path: "createApp", request: request)) ?? false

            if success {
                return
            }
        }

        fail("Could not create server App")
    }

    /// A non-async version of `create()`.
    ///
    /// - Parameters:
    ///   - activate: A boolean indicating whether to activate the application immediately.
    ///   - timeout: The maximum time to wait for application creation. Defaults to 30 seconds.
    /// - Note: This method uses an executor to handle the async operation.
    @available(*, noasync)
    public func create(activate: Bool, timeout: TimeInterval = 30_000_000_000) {
        Executor.execute {
            try await self.create(activate: activate, timeout: timeout)
        }.valueOrFailWithFallback(())
    }

    /// Performs an accessibility audit on the application.
    ///
    /// This method checks the application for various accessibility issues based on the specified audit types.
    ///
    /// - Parameters:
    ///   - auditTypes: The types of accessibility audits to perform. Defaults to `.all`.
    ///   - issueHandler: An optional closure to handle individual accessibility issues.
    ///     - If the closure returns `true`, the issue is ignored.
    ///     - If the closure returns `false` or throws an error, the issue is considered a test failure.
    ///   - fileID: The file identifier for the test context. Defaults to the current file.
    ///   - filePath: The file path for the test context. Defaults to the current file path.
    ///   - line: The line number in the source code. Defaults to the current line.
    ///   - column: The column number in the source code. Defaults to the current column.
    /// - Throws: An error if the accessibility audit fails or cannot be performed.
    @available(iOS 17.0, *)
    public func performAccessibilityAudit(
        for auditTypes: AccessibilityAuditType = .all,
        _ issueHandler: ((AccessibilityAuditIssue) throws -> Bool)? = nil,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) async throws {
        let accessibilityAuditRequest = AccessibilityAuditRequest(
            serverId: serverId,
            accessibilityAuditType: AccessibilityAuditType(rawValue: auditTypes.rawValue)
        )

        let response: AccessibilityAuditResponse = try await callServer(
            path: "performAccessibilityAudit",
            request: accessibilityAuditRequest
        )

        for issue in response.issues {
            do {
                let ignore = try issueHandler?(issue) ?? false
                if !ignore {
                    fail(issue.compactDescription, fileID: fileID, filePath: filePath, line: line, column: column)
                }
            } catch {
                fail(issue.compactDescription, fileID: fileID, filePath: filePath, line: line, column: column)
            }
        }
    }

    /// A non-async version of `performAccessibilityAudit()`.
    ///
    /// - Parameters:
    ///   - auditTypes: The types of accessibility audits to perform. Defaults to `.all`.
    ///   - issueHandler: An optional closure to handle individual accessibility issues.
    ///     - If the closure returns `true`, the issue is ignored.
    ///     - If the closure returns `false` or throws an error, the issue is considered a test failure.
    ///   - fileID: The file identifier for the test context. Defaults to the current file.
    ///   - filePath: The file path for the test context. Defaults to the current file path.
    ///   - line: The line number in the source code. Defaults to the current line.
    ///   - column: The column number in the source code. Defaults to the current column.
    /// - Throws: An error if the accessibility audit fails or cannot be performed.
    @available(iOS 17.0, *)
    public func performAccessibilityAudit(
        for auditTypes: AccessibilityAuditType = .all,
        _ issueHandler: (@Sendable (AccessibilityAuditIssue) throws -> Bool)? = nil,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) throws {
        Executor.execute {
            try await self.performAccessibilityAudit(
                for: auditTypes,
                issueHandler,
                fileID: fileID,
                filePath: filePath,
                line: line,
                column: column
            )
        }.valueOrFailWithFallback(())
    }
}

/// Represents a synchronous API for UI testing, providing methods to interact with and manage application state.
///
/// This class provides synchronous methods for creating, activating, and interacting with an application during UI testing.
/// It serves as a non-async wrapper around the `AsyncApi` class, allowing easier use in synchronous testing contexts.
///
/// - Note: This class is thread-safe and can be used concurrently.
@available(*, noasync)
public class SyncApi: SyncElement, @unchecked Sendable {
    /// The underlying asynchronous API instance.
    let api: AsyncApi

    /// Provides an asynchronous API interface for this synchronous API instance.
    ///
    /// - Returns: An `AsyncApi` wrapping the current `SyncApi` instance.
    public var asyncAPI: AsyncApi { api }

    /// Initializes a synchronous API instance for a specific application.
    ///
    /// - Parameters:
    ///   - appId: The bundle identifier of the application to test. Defaults to the main bundle identifier.
    ///   - activate: A boolean indicating whether to activate the application immediately. Defaults to `true`.
    @available(*, noasync)
    public init(appId: String = Bundle.main.bundleIdentifier!, activate: Bool = true) {
        api = AsyncApi(appId: appId)
        super.init(element: api)
        create(activate: activate)
    }

    /// Initializes a synchronous API instance from an existing asynchronous API.
    ///
    /// - Parameters:
    ///   - asyncApi: The `AsyncApi` instance to wrap.
    public init(asyncApi: AsyncApi) {
        api = asyncApi
        super.init(element: api)
    }

    /// A required initializer that is not implemented.
    ///
    /// - Throws: A fatal error indicating that this initializer is not supported.
    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    /// Simulates pressing the home button on the device.
    ///
    /// - Note: This method uses an executor to handle the async operation.
    public func pressHomeButton() {
        Executor.execute {
            try await self.api.pressHomeButton()
        }.valueOrFailWithFallback(())
    }

    /// Activates the application.
    ///
    /// - Note: This method uses an executor to handle the async operation.
    public func activate() {
        Executor.execute {
            try await self.api.activate()
        }.valueOrFailWithFallback(())
    }

    /// Creates and sets up the application for testing.
    ///
    /// - Parameters:
    ///   - activate: A boolean indicating whether to activate the application immediately.
    ///   - timeout: The maximum time to wait for application creation. Defaults to 30 seconds.
    /// - Note: This method uses an executor to handle the async operation.
    public func create(activate: Bool, timeout: TimeInterval = 30_000_000_000) {
        Executor.execute {
            try await self.api.create(activate: activate, timeout: timeout)
        }.valueOrFailWithFallback(())
    }

    /// Performs an accessibility audit on the application.
    ///
    /// This method checks the application for various accessibility issues based on the specified audit types.
    ///
    /// - Parameters:
    ///   - auditTypes: The types of accessibility audits to perform. Defaults to `.all`.
    ///   - issueHandler: An optional closure to handle individual accessibility issues.
    ///     - If the closure returns `true`, the issue is ignored.
    ///     - If the closure returns `false` or throws an error, the issue is considered a test failure.
    ///   - fileID: The file identifier for the test context. Defaults to the current file.
    ///   - filePath: The file path for the test context. Defaults to the current file path.
    ///   - line: The line number in the source code. Defaults to the current line.
    ///   - column: The column number in the source code. Defaults to the current column.
    /// - Throws: An error if the accessibility audit fails or cannot be performed.
    @available(iOS 17.0, *)
    public func performAccessibilityAudit(
        for auditTypes: AccessibilityAuditType = .all,
        _ issueHandler: (@Sendable (AccessibilityAuditIssue) throws -> Bool)? = nil,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) throws {
        Executor.execute {
            try await self.api.performAccessibilityAudit(
                for: auditTypes,
                issueHandler,
                fileID: fileID,
                filePath: filePath,
                line: line,
                column: column
            )
        }.valueOrFailWithFallback(())
    }
}
