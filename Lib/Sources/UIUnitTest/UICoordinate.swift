import Foundation

public class Coordinate: Codable {
    public var serverId: UUID
    
    var referencedElement: Element
    var screenPoint: CGPoint
    
    deinit {
        let serverId = serverId
        Task {
            let _: Bool = try await callServer(path: "remove", request: RemoveServerItemRequest(serverId: serverId))
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
    
    func tap() async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .tap)
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }
    
    func doubleTap() async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .doubleTap)
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }
    
    public func press(forDuration duration: TimeInterval) async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .press(forDuration: duration))
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }
    
    public func press(forDuration duration: TimeInterval, thenDragTo coordinate: Coordinate) async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .pressAndDrag(forDuration: duration, thenDragTo: coordinate))
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }
    
    public func press(forDuration duration: TimeInterval, thenDragTo coordinate: Coordinate, withVelocity velocity: GestureVelocity, thenHoldForDuration holdDuration: TimeInterval) async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .pressDragAndHold(forDuration: duration, thenDragTo: coordinate, withVelocity: velocity, thenHoldForDuration: holdDuration) )
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
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



public struct TapCoordinateRequest: Codable {
    
    public enum TapType: Codable {
        case tap
        case doubleTap
        case press(forDuration: TimeInterval)
        case pressAndDrag(forDuration: TimeInterval, thenDragTo: Coordinate)
        case pressDragAndHold(forDuration: TimeInterval, thenDragTo: Coordinate, withVelocity: GestureVelocity, thenHoldForDuration: TimeInterval)
    }
    
    public var serverId: UUID
    public var type: TapType
    
    init(serverId: UUID, type: TapType) {
        self.serverId = serverId
        self.type = type
    }
}

