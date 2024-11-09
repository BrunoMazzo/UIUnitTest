import Foundation

public struct ScrollRequest: Codable, Sendable {
    public var serverId: UUID
    public var deltaX: CGFloat
    public var deltaY: CGFloat

    public init(serverId: UUID, deltaX: CGFloat, deltaY: CGFloat) {
        self.serverId = serverId
        self.deltaX = deltaX
        self.deltaY = deltaY
    }
}
