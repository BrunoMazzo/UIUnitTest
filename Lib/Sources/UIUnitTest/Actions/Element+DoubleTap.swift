import Foundation

extension Element {
    public func doubleTap() async throws {
        let activateRequestData = ElementRequest(serverId: serverId)
        
        let _: Bool = try await callServer(path: "doubleTap", request: activateRequestData)
    }
    
    @available(*, noasync)
    public func doubleTap() {
        Executor.execute {
            try await self.doubleTap()
        }
    }
}
