//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 10/3/2023.
//

import Foundation

public enum SwipeDirection: Codable {
    case up, down, left, right
}

extension Query {
    public func swipe(direction: SwipeDirection) async throws {
        let swipeRequest = SwipeRequest(direction: direction, matchers: self.matchers)
        
        let _: Bool = try await callServer(path: "swipe", request: swipeRequest)
    }

    public func swipeUp() async throws {
        try await self.swipe(direction: .up)
    }
    
    public func swipeDown() async throws {
        try await self.swipe(direction: .down)
    }
    
    public func swipeLeft() async throws {
        try await self.swipe(direction: .left)
    }
    
    public func swipeRight() async throws {
        try await self.swipe(direction: .right)
    }

    
}

public struct SwipeRequest: Codable {
    
    public var matchers: [ElementMatcher]
    public var swipeDirection: SwipeDirection
    
    public init(direction: SwipeDirection,
                matchers: [ElementMatcher]) {
        self.swipeDirection = direction
        self.matchers = matchers
    }
}
