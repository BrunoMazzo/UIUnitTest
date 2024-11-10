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
    
    @MainActor
    func isSelected(request: ElementPayload) async throws -> Bool {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.isSelected
    }
    
    @MainActor
    func hasFocus(request: ElementPayload) async throws -> Bool {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.hasFocus
    }
    
    @MainActor
    func isEnabled(request: ElementPayload) async throws -> Bool {
        let rootElement = try cache.getElement(request.serverId)
        return rootElement.isEnabled
    }
    
    @MainActor
    func frame(request: ElementPayload) async throws -> CGRect {
        let element = try cache.getElement(request.serverId)
        return element.frame
    }
    
    @MainActor
    func horizontalSizeClass(request: ElementPayload) async throws -> SizeClass {
        let element = try cache.getElement(request.serverId)
        return SizeClass(rawValue: element.horizontalSizeClass.rawValue)!
    }
    
    @MainActor
    func verticalSizeClass(request: ElementPayload) async throws -> SizeClass {
        let element = try cache.getElement(request.serverId)
        return SizeClass(rawValue: element.verticalSizeClass.rawValue)!
    }
    
    @MainActor
    func elementType(request: ElementPayload) async throws -> UInt {
        let element = try cache.getElement(request.serverId)
        return element.elementType.rawValue
    }
}
