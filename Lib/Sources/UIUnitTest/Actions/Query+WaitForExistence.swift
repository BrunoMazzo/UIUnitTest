//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 12/3/2023.
//
import Foundation

extension Query {
    public func waitForExistence(timeout: TimeInterval) async throws -> Bool {
        let activateRequestData = WaitForExistenceRequest(matchers: self.matchers, timeout: timeout)
        
        let response: WaitForExistenceResponse = try await callServer(path: "waitForExistence", request: activateRequestData)
        
        return response.elementExists
    }
}

public struct WaitForExistenceRequest: Codable {
    
    public var matchers: [ElementMatcher]
    public var timeout: TimeInterval
    
    public init(matchers: [ElementMatcher], timeout: TimeInterval) {
        self.matchers = matchers
        self.timeout = timeout
    }
}


public struct WaitForExistenceResponse: Codable {
    public var elementExists: Bool
    
    public init(elementExists: Bool) {
        self.elementExists = elementExists
    }
}
