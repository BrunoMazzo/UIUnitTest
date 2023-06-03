//
//  File 2.swift
//
//
//  Created by Bruno Mazzo on 9/3/2023.
//

import Foundation

public class Query: ElementTypeQueryProvider {
    
    public var queryServerId: UUID?
    
    init(queryServerId: UUID) {
        self.queryServerId = queryServerId
    }
    
    init(queryRoot: UUID? = nil, queryType: QueryType) async throws {
        let response: QueryResponse = try await callServer(path: "query", request: QueryRequest(queryRoot: queryRoot, queryType: queryType))
        self.queryServerId = response.serverId
    }
    
    deinit {
        if let serverId = queryServerId {
            Task {
                let _: Bool = try await callServer(path: "remove", request: RemoveServerItemRequest(queryRoot: serverId))
            }
        }
    }
    
    /** Returns an element that will use the query for resolution. */
    public var element: Element! {
        get async throws {
            let elementResponse: ElementResponse = try await callServer(path: "elementFromQuery", request: ElementFromQuery(serverId: self.queryServerId!))
            return Element(serverId: elementResponse.serverId)
        }
    }
    
    var allElementsBoundByAccessibilityElement: [Element] {
        get async throws {
            let elementResponse: ElementArrayResponse = try await callServer(path: "allElementsBoundByAccessibilityElement", request: ElementsByAccessibility(serverId: self.queryServerId!))
            return elementResponse.serversId.map { Element(serverId: $0) }
        }
    }
    
    var allElementsBoundByIndex: [Element] {
        get async throws {
            let elementResponse: ElementArrayResponse = try await callServer(path: "allElementsBoundByIndex", request: ElementsByAccessibility(serverId: self.queryServerId!))
            return elementResponse.serversId.map { Element(serverId: $0) }
        }
    }
    
    //
    
    /** Evaluates the query at the time it is called and returns the number of matches found. */
    public var count: Int {
        get async throws {
            let response: CountResponse = try await callServer(path: "count", request: CountRequest(serverId: self.queryServerId!))
            return response.count
        }
    }
    
    /** Returns an element that will use the index into the query's results to determine which underlying accessibility element it is matched with. */
    public func element(boundByIndex index: Int) async throws -> Element {
        let elementResponse: ElementResponse = try await callServer(path: "elementFromQuery", request: ElementFromQuery(serverId: self.queryServerId!, index: index))
        return Element(serverId: elementResponse.serverId)
    }
    
    
    /** Returns an element that matches the predicate. The predicate will be evaluated against objects of type id<XCUIElementAttributes>. */
    public func element(matching predicate: NSPredicate) async throws -> Element {
        let response: ElementResponse = try await callServer(path: "elementMatchingPredicate", request: ElementMatchingPredicateRequest(serverId: self.queryServerId!, predicate: predicate))
        return Element(serverId: response.serverId)
    }
    
    
    /** Returns an element that matches the type and identifier. */
    public func element(matching elementType: Element.ElementType, identifier: String?) async throws -> Element {
        let response: ElementResponse = try await callServer(path: "elementMatchingPredicate", request: ElementFromQuery(serverId: self.queryServerId!, elementType: elementType, identifier: identifier))
        return Element(serverId: response.serverId)
    }
    //    open func element(matchingType elementType: Any!, identifier: Any!) -> Element!
    
    
    /** Keyed subscripting is implemented as a shortcut for matching an identifier only. For example, app.descendants["Foo"] -> XCUIElement. */
    public subscript(_ identifier: String) -> Element {
        get async throws {
            let response: ElementResponse = try await callServer(path: "element", request: ElementRequest(queryRoot: queryServerId, identifier: identifier))
            return Element(serverId: response.serverId)
        }
    }
    
    
    /** Returns a new query that finds the descendants of all the elements found by the receiver. */
    func descendants(matching elementType: Element.ElementType) async throws -> Query {
        let response: QueryResponse = try await callServer(path: "queryDescendants", request: DescendantsFromQuery(serverId: self.queryServerId!, elementType: elementType))
        return Query(queryServerId: response.serverId)
        
    }

    
    
    /** Returns a new query that finds the direct children of all the elements found by the receiver. */
    //    open func children(matchingType type: Any!) -> Element!
    
    
    /** Returns a new query that applies the specified attributes or predicate to the receiver. The predicate will be evaluated against objects of type id<XCUIElementAttributes>. */
    //    open func matchingPredicate(_ predicate: Any!) -> Element!
    
    //    open func matchingType(_ elementType: Any!, identifier: Any!) -> Element!
    
    //    open func matchingIdentifier(_ identifier: Any!) -> Element!
    
    
    /** Returns a new query for finding elements that contain a descendant matching the specification. The predicate will be evaluated against objects of type id<XCUIElementAttributes>. */
    //    open func containingPredicate(_ predicate: Any!) -> Element!
    
    //    open func containingType(_ elementType: Any!, identifier: Any!) -> Element!
}

extension Query {
    public enum QueryType: Int, Codable {
        case activityIndicators
        case alerts
        case browsers
        case buttons
        case cells
        case checkBoxes
        case collectionViews
        case colorWells
        case comboBoxes
        case datePickers
        case decrementArrows
        case dialogs
        case disclosureTriangles
        case disclosedChildRows
        case dockItems
        case drawers
        case grids
        case groups
        case handles
        case helpTags
        case icons
        case images
        case incrementArrows
        case keyboards
        case keys
        case layoutAreas
        case layoutItems
        case levelIndicators
        case links
        case maps
        case mattes
        case menuBarItems
        case menuBars
        case menuButtons
        case menuItems
        case menus
        case navigationBars
        case otherElements
        case outlineRows
        case outlines
        case pageIndicators
        case pickerWheels
        case pickers
        case popUpButtons
        case popovers
        case progressIndicators
        case radioButtons
        case radioGroups
        case ratingIndicators
        case relevanceIndicators
        case rulerMarkers
        case rulers
        case scrollBars
        case scrollViews
        case searchFields
        case secureTextFields
        case segmentedControls
        case sheets
        case sliders
        case splitGroups
        case splitters
        case staticTexts
        case statusBars
        case statusItems
        case steppers
        case switches
        case tabBars
        case tabGroups
        case tableColumns
        case tableRows
        case tables
        case textFields
        case textViews
        case timelines
        case toggles
        case toolbarButtons
        case toolbars
        case touchBars
        case valueIndicators
        case webViews
        case windows
    }
}

public struct QueryRequest: Codable {
    
    public var queryRoot: UUID?
    public var queryType: Query.QueryType
    
    init(queryRoot: UUID? = nil, queryType: Query.QueryType) {
        self.queryRoot = queryRoot
        self.queryType = queryType
    }
}

public struct QueryResponse: Codable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct CountRequest: Codable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct CountResponse: Codable {
    public var count: Int
    
    public init(count: Int) {
        self.count = count
    }
}

public struct ElementMatchingPredicateRequest: Codable {
    public let serverId: UUID
    public let predicate: NSPredicate
            
    public init(serverId: UUID, predicate: NSPredicate) {
        self.serverId = serverId
        self.predicate = predicate
    }
    
    enum CodingKeys: CodingKey {
        case serverId
        case predicate
    }
    
    public func encode(to encoder: Encoder) throws {
        let data = try NSKeyedArchiver.archivedData(
            withRootObject: predicate,
            requiringSecureCoding: true
        )
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serverId, forKey: .serverId)
        try container.encode(data, forKey: .predicate)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.serverId = try container.decode(UUID.self, forKey: .serverId)
        
        let data = try container.decode(Data.self, forKey: .predicate)

        self.predicate = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSPredicate.self], from:data) as! NSPredicate
    }
}

public struct ElementFromQuery: Codable {
    public let serverId: UUID
    public let index: Int?
    public let elementType: Element.ElementType?
    public let identifier: String?
    
    public init(serverId: UUID, index: Int? = nil) {
        self.serverId = serverId
        self.index = index
        self.elementType = nil
        self.identifier = nil
    }
    
    public init(serverId: UUID, elementType: Element.ElementType, identifier: String? = nil) {
        self.serverId = serverId
        self.elementType = elementType
        self.identifier = identifier
        self.index = nil
    }
}


public struct DescendantsFromQuery: Codable {
    public let serverId: UUID
    public let elementType: Element.ElementType
    
    public init(serverId: UUID, elementType: Element.ElementType) {
        self.serverId = serverId
        self.elementType = elementType
    }
}

public struct ElementsByAccessibility: Codable {
    public let serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}


