import UIUnitTestAPI
import XCTest

extension UIServer {
    @MainActor
    func exists(request: ElementRequest) async throws -> ExistsResponse {
        let element = try cache.getElement(request.serverId)
        let exists = element.exists

        return ExistsResponse(exists: exists)
    }

    @MainActor
    func waitForExistence(request: WaitForExistenceRequest) async throws -> WaitForExistenceResponse {
        let element = try cache.getElement(request.serverId)
        let exists = element.waitForExistence(timeout: request.timeout)

        return WaitForExistenceResponse(elementExists: exists)
    }

    @MainActor
    func waitForNonExistence(request: WaitForExistenceRequest) async throws -> WaitForExistenceResponse {
        let element = try cache.getElement(request.serverId)

        let predicate = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"), object: element)

        let result = await XCTWaiter().fulfillment(of: [predicate], timeout: request.timeout, enforceOrder: false)

        return WaitForExistenceResponse(elementExists: result != .completed)
    }
}
