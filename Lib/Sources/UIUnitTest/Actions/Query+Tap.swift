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
    
    public func twoFingerTap() async throws {
        let activateRequestData = TapRequest(matchers: self.matchers, numberOfTouches: 2)
        
        let _: Bool = try await callServer(path: "tap", request: activateRequestData)
    }
    
    public func tap(withNumberOfTaps numberOfTaps: Int, numberOfTouches: Int) async throws {
        let activateRequestData = TapRequest(matchers: self.matchers, numberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
        
        let _: Bool = try await callServer(path: "tap", request: activateRequestData)
    }
    
    public func press(forDuration duration: TimeInterval) async throws {
        let activateRequestData = TapRequest(matchers: self.matchers, duration: duration)
        
        let _: Bool = try await callServer(path: "tap", request: activateRequestData)
    }
}

public struct TapRequest: Codable {
    
    public var matchers: [ElementMatcher]
    public var duration: TimeInterval?
    public var numberOfTaps: Int?
    public var numberOfTouches: Int?

    public init(matchers: [ElementMatcher], duration: TimeInterval? = nil) {
        self.matchers = matchers
        self.duration = duration
    }
    
    public init(matchers: [ElementMatcher], numberOfTaps: Int? = nil, numberOfTouches: Int? = nil) {
        self.matchers = matchers
        self.numberOfTaps = numberOfTaps
        self.numberOfTouches = numberOfTouches
    }
}
