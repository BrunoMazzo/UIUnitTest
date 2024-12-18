import Foundation
import UIUnitTestAPI

public extension Element {
    func pinch(withScale scale: CGFloat, velocity: CGFloat) async throws {
        let swipeRequest = PinchRequest(serverId: serverId, scale: scale, velocity: velocity)

        let _: Bool = try await callServer(path: "pinch", request: swipeRequest)
    }
}

public extension SyncElement {
    @available(*, noasync)
    func pinch(withScale scale: CGFloat, velocity: CGFloat) {
        Executor.execute {
            try await self.element.pinch(withScale: scale, velocity: velocity)
        }.valueOrFailWithFallback(())
    }
}
