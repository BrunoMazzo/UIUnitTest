import Foundation
import UIUnitTestAPI

public extension Element {
    var exists: Bool {
        get async throws {
            let existsRequestData = ElementPayload(serverId: serverId)
            let existsResponse: ExistsResponse = try await callServer(path: "exists", request: existsRequestData)
            return existsResponse.exists
        }
    }

    func waitForExistence(timeout: TimeInterval) async throws -> Bool {
        let activateRequestData = WaitForExistenceRequest(serverId: serverId, timeout: timeout)
        let response: WaitForExistenceResponse = try await callServer(
            path: "waitForExistence",
            request: activateRequestData
        )
        return response.elementExists
    }

    func waitForNonExistence(timeout: TimeInterval) async throws -> Bool {
        let activateRequestData = WaitForExistenceRequest(serverId: serverId, timeout: timeout)
        let response: WaitForExistenceResponse = try await callServer(path: "waitForNonExistence", request: activateRequestData)
        return !response.elementExists
    }
}
