import Foundation

extension Element {
    public func doubleTap() async throws {
        let activateRequestData = ElementRequest(serverId: serverId)
        
        let _: Bool = try await callServer(path: "doubleTap", request: activateRequestData)
    }
}

extension SyncElement {
    public func doubleTap() {
        self.executor.execute {
            try await self.element.doubleTap()
        }
    }
}
