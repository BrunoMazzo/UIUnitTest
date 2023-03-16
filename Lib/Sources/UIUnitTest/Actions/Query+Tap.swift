//
//  File.swift
//  
//
//  Created by Bruno Mazzo on 9/3/2023.
//

import Foundation

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
