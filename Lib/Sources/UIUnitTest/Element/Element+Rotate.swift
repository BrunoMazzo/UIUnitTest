import Foundation

public extension Element {
    func rotate(_ rotation: CGFloat, withVelocity velocity: CGFloat) async throws {
//        rotation and velocity must have the same sign
        
        let swipeRequest = RotateRequest(serverId: serverId, rotation: rotation, velocity: velocity)
        
        let _: Bool = try await callServer(path: "rotate", request: swipeRequest)
    }

    @available(*, noasync)
    func rotate(_ rotation: CGFloat, withVelocity velocity: CGFloat)  {
        Executor.execute {
            try await self.rotate(rotation, withVelocity: velocity)
        }.valueOrFailWithFallback(())
    }
}


public struct RotateRequest: Codable {
    
    public var serverId: UUID
    public var rotation: CGFloat
    public var velocity: CGFloat
    
    init(serverId: UUID, rotation: CGFloat, velocity: CGFloat) {
        self.serverId = serverId
        self.rotation = rotation
        self.velocity = velocity
    }
}
