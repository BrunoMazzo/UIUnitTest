//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 12/3/2023.
//
import Foundation

public struct WaitForExistenceRequest: Codable {
    
    public var elementServerId: UUID
    public var timeout: TimeInterval
    
    public init(elementServerId: UUID, timeout: TimeInterval) {
        self.elementServerId = elementServerId
        self.timeout = timeout
    }
}


public struct WaitForExistenceResponse: Codable {
    public var elementExists: Bool
    
    public init(elementExists: Bool) {
        self.elementExists = elementExists
    }
}
