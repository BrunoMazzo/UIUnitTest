//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 7/5/2024.
//

import Foundation

public struct AccessibilityAuditType: RawRepresentable, OptionSet {
    
    public var rawValue: Int64
    
    public init(rawValue: Int64) {
        self.rawValue = rawValue
    }
    
    public static let contrast                     = AccessibilityAuditType(rawValue: 1 << 0)
    public static let elementDetection             = AccessibilityAuditType(rawValue: 1 << 1)
    public static let hitRegion                    = AccessibilityAuditType(rawValue: 1 << 2)
    public static let sufficientElementDescription = AccessibilityAuditType(rawValue: 1 << 3)
    
#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH || TARGET_OS_SIMULATOR
    // Types of audits supported on iOS, watchOS, and tvOS
    public static let dynamicType                  = AccessibilityAuditType(rawValue: 1 << 16)
    public static let textClipped                  = AccessibilityAuditType(rawValue: 1 << 17)
    public static let trait                        = AccessibilityAuditType(rawValue: 1 << 18)
    
#elseif TARGET_OS_OSX || TARGET_OS_MACCATALYST
    // Types of audits supported on macOS
    public static let action                       = AccessibilityAuditType(rawValue: 1 << 32)
    public static let parentChild                  = AccessibilityAuditType(rawValue: 1 << 33)
#endif
    public static let all                          = AccessibilityAuditType(rawValue: ~0)
}

public class AccessibilityAuditIssue {
    
    /// The element associated with the issue.
    var element: Element?

    /// A short description about the issue.
    var compactDescription: String
        
    /// A longer description of the issue with more details about the failure.
    var detailedDescription: String
    
    /// The type of audit which generated the issue.
    var auditType: AccessibilityAuditType
    
    public init(element: Element? = nil, compactDescription: String, detailedDescription: String, auditType: AccessibilityAuditType) {
        self.element = element
        self.compactDescription = compactDescription
        self.detailedDescription = detailedDescription
        self.auditType = auditType
    }
}
