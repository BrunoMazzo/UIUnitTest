import Foundation
import UIUnitTestAPI

public extension Element {
    func swipe(direction: SwipeDirection, velocity: GestureVelocity = .default) async throws {
        let swipeRequest = SwipeRequest(serverId: serverId, direction: direction, velocity: velocity.toAPI())

        let _: Bool = try await callServer(path: "swipe", request: swipeRequest)
    }

    func swipeUp(velocity: GestureVelocity = .default) async throws {
        try await swipe(direction: .up, velocity: velocity)
    }

    func swipeDown(velocity: GestureVelocity = .default) async throws {
        try await swipe(direction: .down, velocity: velocity)
    }

    func swipeLeft(velocity: GestureVelocity = .default) async throws {
        try await swipe(direction: .left, velocity: velocity)
    }

    func swipeRight(velocity: GestureVelocity = .default) async throws {
        try await swipe(direction: .right, velocity: velocity)
    }
}

public extension SyncElement {
    @available(*, noasync)
    func swipe(direction: SwipeDirection, velocity: GestureVelocity = .default) {
        Executor.execute {
            try await self.element.swipe(direction: direction, velocity: velocity)
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    func swipeUp(velocity: GestureVelocity = .default) {
        swipe(direction: .up, velocity: velocity)
    }

    @available(*, noasync)
    func swipeDown(velocity: GestureVelocity = .default) {
        swipe(direction: .down, velocity: velocity)
    }

    @available(*, noasync)
    func swipeLeft(velocity: GestureVelocity = .default) {
        swipe(direction: .left, velocity: velocity)
    }

    @available(*, noasync)
    func swipeRight(velocity: GestureVelocity = .default) {
        swipe(direction: .right, velocity: velocity)
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
        case let .custom(value): return .custom(value)
        }
    }
}

extension GestureVelocity: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .custom(CGFloat(value))
    }

    public typealias IntegerLiteralType = Int
}

extension GestureVelocity: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = CGFloat.NativeType

    public init(floatLiteral value: GestureVelocityAPI.FloatLiteralType) {
        self = .custom(value)
    }
}
