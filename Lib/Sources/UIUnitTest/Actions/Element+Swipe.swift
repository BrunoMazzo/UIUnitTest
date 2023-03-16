import Foundation

public enum SwipeDirection: Codable {
    case up, down, left, right
}

extension Element {
    public func swipe(direction: SwipeDirection) async throws {
        let swipeRequest = SwipeRequest(elementServerId: serverId, direction: direction)
        
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
    
    public init(elementServerId: UUID, direction: SwipeDirection) {
        self.elementServerId = elementServerId
        self.swipeDirection = direction
    }
}
