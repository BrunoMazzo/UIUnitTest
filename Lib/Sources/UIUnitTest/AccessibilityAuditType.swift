import Foundation
import UIUnitTestAPI

public struct AccessibilityAuditType: RawRepresentable, OptionSet, Codable, Sendable {
    public var rawValue: UInt64

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    public static let contrast = AccessibilityAuditType(rawValue: 1 << 0)
    public static let elementDetection = AccessibilityAuditType(rawValue: 1 << 1)
    public static let hitRegion = AccessibilityAuditType(rawValue: 1 << 2)
    public static let sufficientElementDescription = AccessibilityAuditType(rawValue: 1 << 3)

    #if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH || TARGET_OS_SIMULATOR
        // Types of audits supported on iOS, watchOS, and tvOS
        public static let dynamicType = AccessibilityAuditType(rawValue: 1 << 16)
        public static let textClipped = AccessibilityAuditType(rawValue: 1 << 17)
        public static let trait = AccessibilityAuditType(rawValue: 1 << 18)

    #elseif TARGET_OS_OSX || TARGET_OS_MACCATALYST
        // Types of audits supported on macOS
        public static let action = AccessibilityAuditType(rawValue: 1 << 32)
        public static let parentChild = AccessibilityAuditType(rawValue: 1 << 33)
    #endif
    public static let all = AccessibilityAuditType(rawValue: ~0)
}

public struct AccessibilityAuditIssue: Sendable {
    /// The element associated with the issue.
    public var element: Element?

    /// A short description about the issue.
    public var compactDescription: String

    /// A longer description of the issue with more details about the failure.
    public var detailedDescription: String

    /// The type of audit which generated the issue.
    public var auditType: AccessibilityAuditType

    public init(data: AccessibilityAuditIssueData) {
        if let element = data.element {
            self.element = Element(serverId: element)
        } else {
            element = nil
        }

        compactDescription = data.compactDescription
        detailedDescription = data.detailedDescription
        auditType = AccessibilityAuditType(rawValue: data.auditType)
    }
}
