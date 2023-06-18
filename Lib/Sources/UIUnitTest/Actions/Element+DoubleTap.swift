import Foundation

extension Element {
    public func doubleTap() async throws {
        let activateRequestData = ElementRequest(elementServerId: serverId)
        
        let _: Bool = try await callServer(path: "doubleTap", request: activateRequestData)
    }
}
