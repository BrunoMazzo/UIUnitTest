import Foundation
import XCTest

public enum SwipeDirection: Codable {
    case up, down, left, right
}

extension Element {
    public func swipe(direction: SwipeDirection, velocity: GestureVelocity = .default) async throws {
        let swipeRequest = SwipeRequest(elementServerId: serverId, direction: direction, velocity: velocity)
        
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
    
    public var elementServerId: UUID
    public var swipeDirection: SwipeDirection
    public var velocity: GestureVelocity
    
    public init(elementServerId: UUID, direction: SwipeDirection, velocity: GestureVelocity) {
        self.elementServerId = elementServerId
        self.swipeDirection = direction
        self.velocity = velocity
    }
}

public struct GestureVelocity : Hashable, Equatable, RawRepresentable, @unchecked Sendable, Codable {
    
    public let rawValue: CGFloat
    
    public init(_ rawValue: CGFloat) {
        self.rawValue = rawValue
    }
    
    public init(rawValue: CGFloat) {
        self.rawValue = rawValue
    }
}

extension GestureVelocity : ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self.init(CGFloat(value))
    }
    
    public typealias IntegerLiteralType = Int
}

extension GestureVelocity : ExpressibleByFloatLiteral {
    
    public typealias FloatLiteralType = CGFloat.NativeType
    
    public init(floatLiteral value: GestureVelocity.FloatLiteralType) {
        self.init(value)
    }
}
extension GestureVelocity {
    
    public static let `default` = GestureVelocity(XCUIGestureVelocity.default.rawValue)
    
    public static let slow =  GestureVelocity(XCUIGestureVelocity.slow.rawValue)
    
    public static let fast = GestureVelocity(XCUIGestureVelocity.fast.rawValue)
}
