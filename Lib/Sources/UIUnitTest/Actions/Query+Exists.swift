//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 9/3/2023.
//

import Foundation

extension Query {
    public func exists() async throws -> Bool {
        let existsRequestData = ExistsRequest(matchers: self.matchers)
        
        let existsResponse: ExistsResponse = try await callServer(path: "exists", request: existsRequestData)
        
        return existsResponse.exists
    }
    
}

public struct ExistsResponse: Codable {
    public var exists: Bool
    
    public init(exists: Bool) {
        self.exists = exists
    }
}

public struct ExistsRequest: Codable {
    public var matchers: [ElementMatcher]
    
    public init(matchers: [ElementMatcher]) {
        self.matchers = matchers
    }
}

