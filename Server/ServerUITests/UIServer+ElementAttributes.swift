import UIUnitTestAPI
import Foundation

extension UIServer {
    @MainActor
    func debugDescription(request: ElementPayload) async throws -> String {
        var debugDescription: String!
        
        if let rootQuery = try? cache.getElementQuery(request.serverId) {
            debugDescription = rootQuery.debugDescription
        } else if let rootElement = try? cache.getElement(request.serverId) {
            debugDescription = rootElement.debugDescription
        } else {
            throw ElementNotFoundError(serverId: request.serverId.uuidString)
        }
        
        return debugDescription
    }
    
    @MainActor
    func identifier(request: ElementPayload) async throws -> String {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.identifier
    }
    
    @MainActor
    func title(request: ElementPayload) async throws -> String {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.title
    }
    
    @MainActor
    func label(request: ElementPayload) async throws -> String {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.label
    }
    
    @MainActor
    func placeholderValue(request: ElementPayload) async throws -> String? {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.placeholderValue
    }
}
