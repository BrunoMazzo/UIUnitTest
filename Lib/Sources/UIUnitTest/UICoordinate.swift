import Foundation

public class Coordinate: Codable {
    var serverId: UUID
    
    var referencedElement: Element
    var screenPoint: CGPoint
    
    deinit {
        let serverId = serverId
        Task {
            let _: Bool = try await callServer(path: "remove", request: RemoveServerItemRequest(queryRoot: serverId))
        }
    }
    
    public init(serverId: UUID, referencedElement: Element, screenPoint: CGPoint) {
        self.serverId = serverId
        self.referencedElement = referencedElement
        self.screenPoint = screenPoint
    }
    
    public func withOffset(_ vector: CGVector) async throws -> Coordinate {
        let request = CoordinateOffsetRequest(coordinatorId: self.serverId, vector: vector)
        let response: CoordinateResponse = try await callServer(path: "coordinateWithOffset", request: request)
        return response.coordinate
    }

}

public struct CoordinateRequest: Codable {
    public let serverId: UUID
    public let normalizedOffset: CGVector
}

public struct CoordinateOffsetRequest: Codable {
    public let coordinatorId: UUID
    public let vector: CGVector
}

public struct CoordinateResponse: Codable {
    public let coordinate: Coordinate
    
    public init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }
}

