//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 9/3/2023.
//

import Foundation

extension Query {
    public func tap() async throws {
        let activateRequestData = TapRequest(matchers: self.matchers)
        
        let _: Bool = try await callServer(path: "tap", request: activateRequestData)
    }
}

public struct TapRequest: Codable {
    
    public var matchers: [ElementMatcher]
    
    public init(matcher: ElementMatcher) {
        self.matchers = [matcher]
    }
    
    public init(matchers: [ElementMatcher]) {
        self.matchers = matchers
    }
}
