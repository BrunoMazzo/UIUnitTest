import Foundation
import UIUnitTestAPI

extension Element {
    public func doubleTap() async throws {
        let activateRequestData = ElementRequest(serverId: serverId)

        let _: Bool = try await callServer(path: "doubleTap", request: activateRequestData)
    }
}

extension SyncElement {
    public func doubleTap() {
        Executor.execute {
            try await self.element.doubleTap()
        }.valueOrFailWithFallback(())
    }
}
