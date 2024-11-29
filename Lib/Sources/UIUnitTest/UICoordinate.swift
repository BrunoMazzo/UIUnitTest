import Foundation
import UIUnitTestAPI

public final class Coordinate: Sendable {
    static let EmptyCoordinate = Coordinate(serverId: UUID.zero, referencedElement: .EmptyElement, screenPoint: .zero)

    public let serverId: UUID

    let referencedElement: Element
    let screenPoint: CGPoint

    deinit {
        let serverId = serverId
        Task {
            let _: Bool = try await callServer(path: "remove", request: ElementPayload(serverId: serverId))
        }
    }

    public init(serverId: UUID, referencedElement: Element, screenPoint: CGPoint) {
        self.serverId = serverId
        self.referencedElement = referencedElement
        self.screenPoint = screenPoint
    }

    public func withOffset(_ vector: CGVector) async throws -> Coordinate {
        let request = CoordinateOffsetRequest(coordinatorId: serverId, vector: vector)
        let response: CoordinateResponse = try await callServer(path: "coordinateWithOffset", request: request)
        return Coordinate(
            serverId: response.coordinateId,
            referencedElement: Element(serverId: response.referencedElementId),
            screenPoint: response.screenPoint
        )
    }

    func tap() async throws {
        let request = TapCoordinateRequest(serverId: serverId, type: .tap)
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }

    func doubleTap() async throws {
        let request = TapCoordinateRequest(serverId: serverId, type: .doubleTap)
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }

    public func press(forDuration duration: TimeInterval) async throws {
        let request = TapCoordinateRequest(serverId: serverId, type: .press(forDuration: duration))
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }

    public func press(forDuration duration: TimeInterval, thenDragTo coordinate: Coordinate) async throws {
        let request = TapCoordinateRequest(
            serverId: serverId,
            type: .pressAndDrag(forDuration: duration, thenDragTo: coordinate.serverId)
        )
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }

    public func press(
        forDuration duration: TimeInterval,
        thenDragTo coordinate: Coordinate,
        withVelocity velocity: GestureVelocityAPI,
        thenHoldForDuration holdDuration: TimeInterval
    ) async throws {
        let request = TapCoordinateRequest(
            serverId: serverId,
            type: .pressDragAndHold(
                forDuration: duration,
                thenDragTo: coordinate.serverId,
                withVelocity: velocity,
                thenHoldForDuration: holdDuration
            )
        )
        let _: Bool = try await callServer(path: "coordinateTap", request: request)
    }
}

public final class SyncCoordinate: Sendable {
    static let EmptyCoordinate = SyncCoordinate(coordinate: .EmptyCoordinate)

    public let coordinate: Coordinate

    public init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }

    @available(*, noasync)
    public func withOffset(_ vector: CGVector) -> SyncCoordinate {
        Executor.execute {
            try SyncCoordinate(coordinate: await self.coordinate.withOffset(vector))
        }.valueOrFailWithFallback(.EmptyCoordinate)
    }

    @available(*, noasync)
    public func tap() {
        Executor.execute {
            try await self.coordinate.tap()
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    public func doubleTap() {
        Executor.execute {
            try await self.coordinate.doubleTap()
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    public func press(forDuration duration: TimeInterval) {
        Executor.execute {
            try await self.coordinate.press(forDuration: duration)
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    public func press(forDuration duration: TimeInterval, thenDragTo coordinate: Coordinate) {
        Executor.execute {
            try await self.coordinate.press(forDuration: duration, thenDragTo: coordinate)
        }.valueOrFailWithFallback(())
    }

    @available(*, noasync)
    public func press(
        forDuration duration: TimeInterval,
        thenDragTo coordinate: Coordinate,
        withVelocity velocity: GestureVelocityAPI,
        thenHoldForDuration holdDuration: TimeInterval
    ) {
        Executor.execute {
            try await self.coordinate.press(
                forDuration: duration,
                thenDragTo: coordinate,
                withVelocity: velocity,
                thenHoldForDuration: holdDuration
            )
        }.valueOrFailWithFallback(())
    }
}
