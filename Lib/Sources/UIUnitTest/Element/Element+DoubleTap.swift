import Foundation
import UIUnitTestAPI

extension Element {
    public func doubleTap() async throws {
        let activateRequestData = ElementRequest(serverId: serverId)

        let _: Bool = try await callServer(path: "doubleTap", request: activateRequestData)
    }

    @available(*, noasync)
    public func doubleTap() {
        Executor.execute {
            try await self.doubleTap()
        }.valueOrFailWithFallback(())
    }
}

extension SyncElement {
    public func doubleTap() {
        Executor.execute {
            try await self.element.doubleTap()
        }.valueOrFailWithFallback(())
    }
}
