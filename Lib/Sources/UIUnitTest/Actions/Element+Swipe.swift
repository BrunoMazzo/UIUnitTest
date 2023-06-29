import Foundation

public enum SwipeDirection: Codable {
    case up, down, left, right
}

extension Element {
    public func swipe(direction: SwipeDirection, velocity: GestureVelocity = .default) async throws {
        let swipeRequest = SwipeRequest(serverId: serverId, direction: direction, velocity: velocity)
        
        let _: Bool = try await callServer(path: "swipe", request: swipeRequest)
    }

    public func swipeUp(velocity: GestureVelocity = .default) async throws {
        try await self.swipe(direction: .up, velocity: velocity)
    }
    
    public func swipeDown(velocity: GestureVelocity = .default) async throws {
        try await self.swipe(direction: .down, velocity: velocity)
    }
    
    public func swipeLeft(velocity: GestureVelocity = .default) async throws {
        try await self.swipe(direction: .left, velocity: velocity)
    }
    
    public func swipeRight(velocity: GestureVelocity = .default) async throws {
        try await self.swipe(direction: .right, velocity: velocity)
    }
}

public struct SwipeRequest: Codable {
    
    public var serverId: UUID
    public var swipeDirection: SwipeDirection
    public var velocity: GestureVelocity
    
    public init(serverId: UUID, direction: SwipeDirection, velocity: GestureVelocity) {
        self.serverId = serverId
        self.swipeDirection = direction
        self.velocity = velocity
    }
}

public enum GestureVelocity: Hashable, Equatable, @unchecked Sendable, Codable {
    case `default`, slow, fast
    case custom(CGFloat)
    
    public init(_ value: CGFloat) {
        self = .custom(value)
    }
}

public struct GestureVelocity2 : Hashable, Equatable, RawRepresentable, @unchecked Sendable, Codable {
    
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
        self = .custom(CGFloat(value))
    }
    
    public typealias IntegerLiteralType = Int
}

extension GestureVelocity : ExpressibleByFloatLiteral {
    
    public typealias FloatLiteralType = CGFloat.NativeType
    
    public init(floatLiteral value: GestureVelocity.FloatLiteralType) {
        self = .custom(value)
    }
}
