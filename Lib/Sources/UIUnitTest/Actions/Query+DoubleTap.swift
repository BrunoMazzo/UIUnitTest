//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 10/3/2023.
//

import Foundation

extension Query {
    public func doubleTap() async throws {
        let activateRequestData = DoubleTapRequest(matchers: self.matchers)
        
        let _: Bool = try await callServer(path: "doubleTap", request: activateRequestData)
    }
}

public struct DoubleTapRequest: Codable {
    
    public var matchers: [ElementMatcher]
    
    public init(matcher: ElementMatcher) {
        self.matchers = [matcher]
    }
    
    public init(matchers: [ElementMatcher]) {
        self.matchers = matchers
    }
}
