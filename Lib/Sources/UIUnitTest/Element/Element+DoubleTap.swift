import Foundation
import UIUnitTestAPI

public extension Element {
    func doubleTap() async throws {
        let activateRequestData = ElementPayload(serverId: serverId)

        let _: Bool = try await callServer(path: "doubleTap", request: activateRequestData)
    }

    @available(*, noasync)
    func doubleTap() {
        Executor.execute {
            try await self.doubleTap()
        }.valueOrFailWithFallback(())
    }
}
