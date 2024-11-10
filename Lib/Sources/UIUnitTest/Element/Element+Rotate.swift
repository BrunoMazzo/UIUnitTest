import Foundation
import UIUnitTestAPI

public extension Element {
    func rotate(_ rotation: CGFloat, withVelocity velocity: CGFloat) async throws {
//        rotation and velocity must have the same sign

        let swipeRequest = RotateRequest(serverId: serverId, rotation: rotation, velocity: velocity)

        let _: Bool = try await callServer(path: "rotate", request: swipeRequest)
    }
}

public extension SyncElement {
    @available(*, noasync)
    func rotate(_ rotation: CGFloat, withVelocity velocity: CGFloat) {
        Executor.execute {
            try await self.element.rotate(rotation, withVelocity: velocity)
        }.valueOrFailWithFallback(())
    }
}
