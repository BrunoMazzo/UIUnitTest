import Foundation

public extension Element {
    func pinch(withScale scale: CGFloat, velocity: CGFloat) async throws {
        let swipeRequest = PinchRequest(serverId: serverId, scale: scale, velocity: velocity)
        
        let _: Bool = try await callServer(path: "pinch", request: swipeRequest)
    }

    @available(*, noasync)
    func pinch(withScale scale: CGFloat, velocity: CGFloat) {
        Executor.execute {
            try await self.pinch(withScale: scale, velocity: velocity)
        }.valueOrFailWithFallback(())
    }
}

public struct PinchRequest: Codable, Sendable {
    
    public var serverId: UUID
    public var scale: CGFloat
    public var velocity: CGFloat
    
    init(serverId: UUID, scale: CGFloat, velocity: CGFloat) {
        self.serverId = serverId
        self.scale = scale
        self.velocity = velocity
    }
}
