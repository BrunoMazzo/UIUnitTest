import Foundation
import UIUnitTestAPI
import XCTest

@available(*, noasync)
public func App() -> SyncApi {
    return SyncApi()
}

public func App() async throws -> AsyncApi {
    return try await AsyncApi()
}

public class AsyncApi: Element, @unchecked Sendable {
    let appId: String

    public var syncAPI: SyncApi { SyncApi(asyncApi: self) }

    public init(appId: String = Bundle.main.bundleIdentifier!, activate: Bool = true) async throws {
        self.appId = appId
        super.init(serverId: UUID())

        try await create(activate: activate)
    }

    @available(*, noasync)
    public init(appId: String = Bundle.main.bundleIdentifier!, activate: Bool = true) {
        self.appId = appId
        super.init(serverId: UUID())

        create(activate: activate)
    }

    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    public func pressHomeButton() async throws {
        let _: Bool = try await callServer(path: "HomeButton", request: HomeButtonRequest())
    }

    @available(*, noasync)
    public func pressHomeButton() {
        Executor.execute {
            try await self.pressHomeButton()
        }.valueOrFailWithFallback(())
    }

    public func activate() async throws {
        let activateRequestData = ActivateRequest(serverId: serverId)

        let _: Bool = try await callServer(path: "Activate", request: activateRequestData)
    }

    @available(*, noasync)
    public func activate() {
        Executor.execute {
            try await self.activate()
        }.valueOrFailWithFallback(())
    }

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

    @available(*, noasync)
    public func create(activate: Bool, timeout: TimeInterval = 30_000_000_000) {
        Executor.execute {
            try await self.create(activate: activate, timeout: timeout)
        }.valueOrFailWithFallback(())
    }

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
            accessibilityAuditType: auditTypes.rawValue
        )

        let response: AccessibilityAuditResponse = try await callServer(
            path: "performAccessibilityAudit",
            request: accessibilityAuditRequest
        )

        for issue in response.issues {
            do {
                let ignore = try issueHandler?(AccessibilityAuditIssue(data: issue)) ?? false
                if !ignore {
                    fail(issue.compactDescription, fileID: fileID, filePath: filePath, line: line, column: column)
                }
            } catch {
                fail(issue.compactDescription, fileID: fileID, filePath: filePath, line: line, column: column)
            }
        }
    }

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
            try await self.performAccessibilityAudit(for: auditTypes, issueHandler, fileID: fileID, filePath: filePath, line: line, column: column)
        }.valueOrFailWithFallback(())
    }
}

@available(*, noasync)
public class SyncApi: SyncElement, @unchecked Sendable {
    let api: AsyncApi

    public var asyncAPI: AsyncApi { api }

    @available(*, noasync)
    public init(appId: String = Bundle.main.bundleIdentifier!, activate: Bool = true) {
        api = AsyncApi(appId: appId)
        super.init(element: api)
        create(activate: activate)
    }

    public init(asyncApi: AsyncApi) {
        api = asyncApi
        super.init(element: api)
    }

    required init(from _: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    public func pressHomeButton() {
        Executor.execute {
            try await self.api.pressHomeButton()
        }.valueOrFailWithFallback(())
    }

    public func activate() {
        Executor.execute {
            try await self.api.activate()
        }.valueOrFailWithFallback(())
    }

    public func create(activate: Bool, timeout: TimeInterval = 30_000_000_000) {
        Executor.execute {
            try await self.api.create(activate: activate, timeout: timeout)
        }.valueOrFailWithFallback(())
    }

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
            try await self.api.performAccessibilityAudit(for: auditTypes, issueHandler, fileID: fileID, filePath: filePath, line: line, column: column)
        }.valueOrFailWithFallback(())
    }
}
