import Foundation
import UIUnitTestAPI

extension Element {
    public func swipe(direction: SwipeDirection, velocity: GestureVelocity = .default) async throws {
        let swipeRequest = SwipeRequest(serverId: serverId, direction: direction, velocity: velocity.toAPI())
        
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

extension SyncElement {
    @available(*, noasync)
    public func swipe(direction: SwipeDirection, velocity: GestureVelocity = .default) {
        Executor.execute {
            try await self.element.swipe(direction: direction, velocity: velocity)
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    public func swipeUp(velocity: GestureVelocity = .default) {
        self.swipe(direction: .up, velocity: velocity)
    }

    @available(*, noasync)
    public func swipeDown(velocity: GestureVelocity = .default) {
        self.swipe(direction: .down, velocity: velocity)
    }

    @available(*, noasync)
    public func swipeLeft(velocity: GestureVelocity = .default) {
        self.swipe(direction: .left, velocity: velocity)
    }

    @available(*, noasync)
    public func swipeRight(velocity: GestureVelocity = .default) {
        self.swipe(direction: .right, velocity: velocity)
    }
}

public enum GestureVelocity: Hashable, Equatable, Sendable, Codable {
    case `default`, slow, fast
    case custom(CGFloat)
    
    public init(_ value: CGFloat) {
        self = .custom(value)
    }
    
    public func toAPI() -> GestureVelocityAPI {
        switch self {
        case .default: return .default
        case .slow: return .slow
        case .fast: return .fast
        case .custom(let value): return .custom(value)
        }
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
    
    public init(floatLiteral value: GestureVelocityAPI.FloatLiteralType) {
        self = .custom(value)
    }
}


