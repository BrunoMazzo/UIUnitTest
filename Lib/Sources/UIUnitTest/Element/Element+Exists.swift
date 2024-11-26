import Foundation
import UIUnitTestAPI

public extension Element {
    func exists() async throws -> Bool {
        let existsRequestData = ElementPayload(serverId: serverId)
        let existsResponse: ExistsResponse = try await callServer(path: "exists", request: existsRequestData)
        return existsResponse.exists
    }

    /** Waits the specified amount of time for the element's exist property to be true and returns false if the timeout expires without the element coming into existence. */
    func waitForExistence(timeout: TimeInterval) async throws -> Bool {
        let activateRequestData = WaitForExistenceRequest(serverId: serverId, timeout: timeout)
        let response: WaitForExistenceResponse = try await callServer(path: "waitForExistence", request: activateRequestData)
        return response.elementExists
    }

    func waitForNonExistence(timeout: TimeInterval) async throws -> Bool {
        let activateRequestData = WaitForExistenceRequest(serverId: serverId, timeout: timeout)
        let response: WaitForExistenceResponse = try await callServer(path: "waitForNonExistence", request: activateRequestData)
        return !response.elementExists
    }
}
