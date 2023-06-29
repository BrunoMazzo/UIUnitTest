import Foundation
import XCTest

actor Cache {
    private var queryIds: [UUID: XCUIElementTypeQueryProvider] = [:]
    private var elementIds: [UUID: XCUIElement] = [:]
    private var coordinates: [UUID: XCUICoordinate] = [:]
    private var applications: [UUID: XCUIApplication] = [:]
        
    func add(application: XCUIApplication, id: UUID) {
        applications[id] = application
        queryIds[id] = application
        elementIds[id] = application
    }
    
    func add(coordinate: XCUICoordinate) -> UUID {
        let id = UUID()
        coordinates[id] = coordinate
        return id
    }
    
    func add(query: XCUIElementTypeQueryProvider) -> UUID {
        let id = UUID()
        queryIds[id] = query
        return id
    }
    
    func add(element: XCUIElement) -> UUID {
        let id = UUID()
        queryIds[id] = element
        elementIds[id] = element
        return id
    }
    
    func add(elements: [XCUIElement]) -> [UUID] {
        var ids = [UUID]()
        for element in elements {
            let id = self.add(element: element)
            ids.append(id)
        }
        
        return ids
    }
    
    func remove(_ id: UUID) {
        queryIds[id] = nil
        elementIds[id] = nil
        coordinates[id] = nil
        applications[id] = nil
    }
    
    func getApplication(_ id: UUID) throws -> XCUIApplication {
        guard let application = applications[id] else {
            throw ApplicationNotFoundError(serverId: id.uuidString)
        }
        
        return application
    }
    
    func getQuery(_ id: UUID) throws -> XCUIElementTypeQueryProvider {
        guard let query = queryIds[id] else {
            throw QueryNotFoundError(serverId: id.uuidString)
        }
        
        return query
    }
    
    func getElement(_ id: UUID) throws -> XCUIElement {
        guard let element = elementIds[id] else {
            throw ElementNotFoundError(serverId: id.uuidString)
        }
        
        return element
    }
    
    func getElementQuery(_ id: UUID) throws -> XCUIElementQuery {
        let rootQuery = try self.getQuery(id)
        
        guard let query = rootQuery as? XCUIElementQuery else {
            throw WrongQueryTypeFoundError(serverId: id.uuidString)
        }
        
        return query
    }
    
    func getCoordinate(_ id: UUID) throws -> XCUICoordinate {
        guard let coordinate = self.coordinates[id] else {
            throw CoordinateNotFoundError(serverId: id.uuidString)
        }
        
        return coordinate
    }
}
