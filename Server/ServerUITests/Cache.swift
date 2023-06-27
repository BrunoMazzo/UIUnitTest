import Foundation
import XCTest

actor Cache {
    private var queryIds: [UUID: XCUIElementTypeQueryProvider] = [:]
    private var elementIds: [UUID: XCUIElement] = [:]
    private var coordinates: [UUID: XCUICoordinate] = [:]
    
    func add(coordinate: XCUICoordinate) -> UUID {
        let id = UUID()
        coordinates[id] = coordinate
        return id
    }
    
    func add(query: XCUIElementTypeQueryProvider?) -> UUID {
        let id = UUID()
        queryIds[id] = query
        return id
    }
    
    func add(element: XCUIElement?) -> UUID {
        let id = UUID()
        queryIds[id] = element
        elementIds[id] = element
        return id
    }
    
    func add(elements: [XCUIElement?]) -> [UUID] {
        var ids = [UUID]()
        for element in elements {
            let id = self.add(element: element)
            ids.append(id)
        }
        
        return ids
    }
    
    func removeQuery(_ id: UUID) {
        queryIds[id] = nil
    }
    
    func removeElement(_ id: UUID) {
        queryIds[id] = nil
        elementIds[id] = nil
    }
    
    func removeCoordinate(_ id: UUID) {
        coordinates[id] = nil
    }
    
    func getQuery(_ id: UUID) throws -> XCUIElementTypeQueryProvider {
        guard let query = queryIds[id] else {
            throw QueryNotFoundError(queryServerId: id.uuidString)
        }
        
        return query
    }
    
    func getElement(_ id: UUID) throws -> XCUIElement {
        guard let element = elementIds[id] else {
            throw ElementNotFoundError(elementServerId: id.uuidString)
        }
        
        return element
    }
    
    func getElementQuery(_ id: UUID) throws -> XCUIElementQuery {
        let rootQuery = try self.getQuery(id)
        
        guard let query = rootQuery as? XCUIElementQuery else {
            throw WrongQueryTypeFoundError(queryServerId: id.uuidString)
        }
        
        return query
    }
    
    func getCoordinate(_ id: UUID) throws -> XCUICoordinate {
        guard let coordinate = self.coordinates[id] else {
            throw CoordinateNotFoundError(coordinateId: id.uuidString)
        }
        
        return coordinate
    }
}
