//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 7/5/2024.
//

import Foundation

public struct AccessibilityAuditType: RawRepresentable, OptionSet, Codable, Sendable {
    
    public var rawValue: UInt64
    
    public init(rawValue: UInt64) {
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

public struct AccessibilityAuditIssue: Codable, Sendable {
    
    /// The element associated with the issue.
    public var element: Element?

    /// A short description about the issue.
    public var compactDescription: String
        
    /// A longer description of the issue with more details about the failure.
    public var detailedDescription: String
    
    /// The type of audit which generated the issue.
    public var auditType: AccessibilityAuditType
    
    public init(element: UUID? = nil, compactDescription: String, detailedDescription: String, auditType: AccessibilityAuditType) {
        if let element = element {
            self.element = Element(serverId: element)
        } else {
            self.element = nil
        }
        
        self.compactDescription = compactDescription
        self.detailedDescription = detailedDescription
        self.auditType = auditType
    }
    
    enum CodingKeys: CodingKey {
        case element
        case compactDescription
        case detailedDescription
        case auditType
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let element = try container.decodeIfPresent(UUID.self, forKey: .element) {
            self.element = Element(serverId: element)
        }
        
        self.compactDescription = try container.decode(String.self, forKey: .compactDescription)
        self.detailedDescription = try container.decode(String.self, forKey: .detailedDescription)
        self.auditType = try container.decode(AccessibilityAuditType.self, forKey: .auditType)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(element?.serverId, forKey: .element)
        try container.encode(compactDescription, forKey: .compactDescription)
        try container.encode(detailedDescription, forKey: .detailedDescription)
        try container.encode(auditType, forKey: .auditType)
    }
}

public struct AccessibilityAuditRequest: Codable, Sendable {
    public var serverId: UUID
    public var accessibilityAuditType: AccessibilityAuditType
}


public struct AccessibilityAuditResponse: Codable, Sendable {
    public var issues: [AccessibilityAuditIssue]
    
    public init(issues: [AccessibilityAuditIssue]) {
        self.issues = issues
    }
}
