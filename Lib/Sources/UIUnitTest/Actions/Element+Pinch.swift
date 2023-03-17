import Foundation

public extension Element {
    func pinch(withScale scale: CGFloat, velocity: CGFloat) async throws {
        let swipeRequest = PinchRequest(elementServerId: serverId, scale: scale, velocity: velocity)
        
        let _: Bool = try await callServer(path: "pinch", request: swipeRequest)
    }
}

public struct PinchRequest: Codable {
    
    public var elementServerId: UUID
    public var scale: CGFloat
    public var velocity: CGFloat
    
    init(elementServerId: UUID, scale: CGFloat, velocity: CGFloat) {
        self.elementServerId = elementServerId
        self.scale = scale
        self.velocity = velocity
    }
}
