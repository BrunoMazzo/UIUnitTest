import Foundation

public extension Element {
    func rotate(_ rotation: CGFloat, withVelocity velocity: CGFloat) async throws {
//        rotation and velocity must have the same sign
        
        let swipeRequest = RotateRequest(elementServerId: serverId, rotation: rotation, velocity: velocity)
        
        let _: Bool = try await callServer(path: "rotate", request: swipeRequest)
    }
}

public struct RotateRequest: Codable {
    
    public var elementServerId: UUID
    public var rotation: CGFloat
    public var velocity: CGFloat
    
    init(elementServerId: UUID, rotation: CGFloat, velocity: CGFloat) {
        self.elementServerId = elementServerId
        self.rotation = rotation
        self.velocity = velocity
    }
}
