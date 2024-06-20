import Foundation

public final class Coordinate: Sendable {
    
    static let EmptyCoordinate = Coordinate(serverId: UUID.zero, referencedElement: .EmptyElement, screenPoint: .zero)
    
    public let serverId: UUID
    
    let referencedElement: Element
    let screenPoint: CGPoint
    
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
        return Coordinate(serverId: response.coordinateId, referencedElement: Element(serverId: response.referencedElementId), screenPoint: response.screenPoint)
    }
    
    @available(*, noasync)
    public func withOffset(_ vector: CGVector) -> Coordinate {
        Executor.execute {
            try await self.withOffset(vector)
        }.valueOrFailWithFallback(.EmptyCoordinate)
    }
    
    func tap() async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .tap)
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }
    
    @available(*, noasync)
    public func tap() {
        Executor.execute {
            try await self.tap()
        }.valueOrFailWithFallback(())
    }
    
    func doubleTap() async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .doubleTap)
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }
    
    @available(*, noasync)
    public func doubleTap() {
        Executor.execute {
            try await self.doubleTap()
        }.valueOrFailWithFallback(())
    }
    
    public func press(forDuration duration: TimeInterval) async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .press(forDuration: duration))
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }
    
    @available(*, noasync)
    public func press(forDuration duration: TimeInterval) {
        Executor.execute {
            try await self.press(forDuration: duration)
        }.valueOrFailWithFallback(())
    }
    
    public func press(forDuration duration: TimeInterval, thenDragTo coordinate: Coordinate) async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .pressAndDrag(forDuration: duration, thenDragTo: coordinate.serverId))
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }
    
    @available(*, noasync)
    public func press(forDuration duration: TimeInterval, thenDragTo coordinate: Coordinate) {
        Executor.execute {
            try await self.press(forDuration: duration, thenDragTo: coordinate)
        }.valueOrFailWithFallback(())
    }
    
    public func press(forDuration duration: TimeInterval, thenDragTo coordinate: Coordinate, withVelocity velocity: GestureVelocity, thenHoldForDuration holdDuration: TimeInterval) async throws {
        let request = TapCoordinateRequest(serverId: self.serverId, type: .pressDragAndHold(forDuration: duration, thenDragTo: coordinate.serverId, withVelocity: velocity, thenHoldForDuration: holdDuration) )
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }

    @available(*, noasync)
    public func press(forDuration duration: TimeInterval, thenDragTo coordinate: Coordinate, withVelocity velocity: GestureVelocity, thenHoldForDuration holdDuration: TimeInterval) {
        Executor.execute {
            try await self.press(forDuration: duration, thenDragTo: coordinate, withVelocity: velocity, thenHoldForDuration: holdDuration)
        }.valueOrFailWithFallback(())
    }
}

public struct CoordinateRequest: Codable, Sendable {
    public let serverId: UUID
    public let normalizedOffset: CGVector
}

public struct CoordinateOffsetRequest: Codable, Sendable {
    public let coordinatorId: UUID
    public let vector: CGVector
}

public struct CoordinateResponse: Codable, Sendable {
    public var coordinateId: UUID
    public var referencedElementId: UUID
    public var screenPoint: CGPoint

    public init(coordinateId: UUID, referencedElementId: UUID, screenPoint: CGPoint) {
        self.coordinateId = coordinateId
        self.referencedElementId = referencedElementId
        self.screenPoint = screenPoint
    }
}

public struct TapCoordinateRequest: Codable, Sendable {
    
    public enum TapType: Codable, Sendable {
        case tap
        case doubleTap
        case press(forDuration: TimeInterval)
        case pressAndDrag(forDuration: TimeInterval, thenDragTo: UUID)
        case pressDragAndHold(forDuration: TimeInterval, thenDragTo: UUID, withVelocity: GestureVelocity, thenHoldForDuration: TimeInterval)
    }
    
    public var serverId: UUID
    public var type: TapType
    
    init(serverId: UUID, type: TapType) {
        self.serverId = serverId
        self.type = type
    }
}
