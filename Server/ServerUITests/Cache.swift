import Foundation
import XCTest

actor Cache {
    private var queryIds: [UUID: XCUIElementTypeQueryProvider] = [:]
    private var elementIds: [UUID: XCUIElement] = [:]
    
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
    
    func getQuery(_ id: UUID) -> XCUIElementTypeQueryProvider? {
        return queryIds[id]
    }
    
    func getElement(_ id: UUID) -> XCUIElement? {
        return elementIds[id]
    }
}
