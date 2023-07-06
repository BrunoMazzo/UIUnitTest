import Foundation

public class Element: ElementTypeQueryProvider, Codable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
    
    deinit {
        Task { [serverId] in
            let _: Bool = try await callServer(path: "remove", request: RemoveServerItemRequest(serverId: serverId))
        }
    }
    
    public var exists: Bool {
        get async throws {
            let existsRequestData = ElementRequest(serverId: serverId)
            
            let existsResponse: ExistsResponse = try await callServer(path: "exists", request: existsRequestData)
            
            return existsResponse.exists
        }
    }

    /** Waits the specified amount of time for the element's exist property to be true and returns false if the timeout expires without the element coming into existence. */
    public func waitForExistence(timeout: TimeInterval) async throws -> Bool {
        let activateRequestData = WaitForExistenceRequest(serverId: serverId, timeout: timeout)
        
        let response: WaitForExistenceResponse = try await callServer(path: "waitForExistence", request: activateRequestData)
        
        return response.elementExists
    }


    /** Whether or not a hit point can be computed for the element for the purpose of synthesizing events. */
    public var isHittable: Bool {
        get async throws {
            let existsRequestData = ElementRequest(serverId: serverId)
            
            let existsResponse: IsHittableResponse = try await callServer(path: "isHittable", request: existsRequestData)
            
            return existsResponse.isHittable
        }
    }
    
    // Need better way to represent any :c
    public var value: String? {
        get async throws {
            let valueRequest = ElementRequest(serverId: serverId)
            
            let valueResponse: ValueResponse = try await callServer(path: "value", request: valueRequest)
            
            return valueResponse.value
        }
    }

    /** Returns a query for all descendants of the element matching the specified type. */
    public func descendants(matching type: Element.ElementType) async throws -> Query {
        let descendantsFromElement = ElementTypeRequest(serverId: self.serverId, elementType: type)
        
        let queryResponse: QueryResponse = try await callServer(path: "elementDescendants", request: descendantsFromElement)
        
        return Query(serverId: queryResponse.serverId)
    }
    
    /** Returns a query for direct children of the element matching the specified type. */
    public func children(matching type: Element.ElementType) async throws -> Query {
        let request = ChildrenMatchinType(serverId: self.serverId, elementType: type)
        
        let queryResponse: QueryResponse = try await callServer(path: "children", request: request)
        
        return Query(serverId: queryResponse.serverId)
    }

    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) async throws {
        let activateRequestData = ScrollRequest(serverId: self.serverId, deltaX: deltaX, deltaY: deltaY)
        let _: Bool = try await callServer(path: "scroll", request: activateRequestData)
    }

    
    public func enterText(_ textToEnter: String) async throws {
        let activateRequestData = EnterTextRequest(serverId: self.serverId, textToEnter: textToEnter)
        let _: Bool = try await callServer(path: "enterText", request: activateRequestData)
    }
    
    public var debugDescription: String {
        get async throws {
            try await callServer(path: "debugDescription", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var identifier: String {
        get async throws {
            return try await callServer(path: "identifier", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var title: String {
        get async throws {
            return try await callServer(path: "title", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var label: String {
        get async throws {
            return try await callServer(path: "label", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var placeholderValue: String? {
        get async throws {
            return try await callServer(path: "placeholderValue", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var isSelected: Bool {
        get async throws {
            return try await callServer(path: "isSelected", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var hasFocus: Bool {
        get async throws {
            return try await callServer(path: "hasFocus", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var isEnabled: Bool {
        get async throws {
            return try await callServer(path: "isEnabled", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public func coordinate(withNormalizedOffset normalizedOffset: CGVector) async throws -> Coordinate {
        let request = CoordinateRequest(serverId: self.serverId, normalizedOffset: normalizedOffset)
        
        let response: CoordinateResponse = try await callServer(path: "coordinate", request: request)
        
        return response.coordinate
    }
    
    public var frame: CGRect {
        get async throws {
            return try await callServer(path: "frame", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var horizontalSizeClass: SizeClass {
        get async throws {
            return try await callServer(path: "horizontalSizeClass", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var verticalSizeClass: SizeClass {
        get async throws {
            return try await callServer(path: "verticalSizeClass", request: ElementRequest(serverId: self.serverId))
        }
    }
    
    public var elementType: ElementType {
        get async throws {
            return try await callServer(path: "elementType", request: ElementRequest(serverId: self.serverId))
        }
    }
}

public extension Element {
    enum ElementType : UInt, @unchecked Sendable, Codable {
    
        case any = 0
        
        case other = 1
        
        case application = 2
        
        case group = 3
        
        case window = 4
        
        case sheet = 5
        
        case drawer = 6
        
        case alert = 7
        
        case dialog = 8
        
        case button = 9
        
        case radioButton = 10
        
        case radioGroup = 11
        
        case checkBox = 12
        
        case disclosureTriangle = 13
        
        case popUpButton = 14
        
        case comboBox = 15
        
        case menuButton = 16
        
        case toolbarButton = 17
        
        case popover = 18
        
        case keyboard = 19
        
        case key = 20
        
        case navigationBar = 21
        
        case tabBar = 22
        
        case tabGroup = 23
        
        case toolbar = 24
        
        case statusBar = 25
        
        case table = 26
        
        case tableRow = 27
        
        case tableColumn = 28
        
        case outline = 29
        
        case outlineRow = 30
        
        case browser = 31
        
        case collectionView = 32
        
        case slider = 33
        
        case pageIndicator = 34
        
        case progressIndicator = 35
        
        case activityIndicator = 36
        
        case segmentedControl = 37
        
        case picker = 38
        
        case pickerWheel = 39
        
        case `switch` = 40
        
        case toggle = 41
        
        case link = 42
        
        case image = 43
        
        case icon = 44
        
        case searchField = 45
        
        case scrollView = 46
        
        case scrollBar = 47
        
        case staticText = 48
        
        case textField = 49
        
        case secureTextField = 50
        
        case datePicker = 51
        
        case textView = 52
        
        case menu = 53
        
        case menuItem = 54
        
        case menuBar = 55
        
        case menuBarItem = 56
        
        case map = 57
        
        case webView = 58
        
        case incrementArrow = 59
        
        case decrementArrow = 60
        
        case timeline = 61
        
        case ratingIndicator = 62
        
        case valueIndicator = 63
        
        case splitGroup = 64
        
        case splitter = 65
        
        case relevanceIndicator = 66
        
        case colorWell = 67
        
        case helpTag = 68
        
        case matte = 69
        
        case dockItem = 70
        
        case ruler = 71
        
        case rulerMarker = 72
        
        case grid = 73
        
        case levelIndicator = 74
        
        case cell = 75
        
        case layoutArea = 76
        
        case layoutItem = 77
        
        case handle = 78
        
        case stepper = 79
        
        case tab = 80
        
        case touchBar = 81
        
        case statusItem = 82
    }
}

public struct ScrollRequest: Codable {
    public var serverId: UUID
    public var deltaX: CGFloat
    public var deltaY: CGFloat
    
    init(serverId: UUID, deltaX: CGFloat, deltaY: CGFloat) {
        self.serverId = serverId
        self.deltaX = deltaX
        self.deltaY = deltaY
    }
}

public struct ElementByIdRequest: Codable {
    public var queryRoot: UUID
    public var identifier: String
}

public struct QueryByIdRequest: Codable {
    public var queryRoot: UUID
    public var identifier: String
}

public struct ElementResponse: Codable {
    public var serverId: UUID
    
    public init(serverId: UUID) {
        self.serverId = serverId
    }
}

public struct ElementArrayResponse: Codable {
    public var serversId: [UUID]
    
    public init(serversId: [UUID]) {
        self.serversId = serversId
    }
}

public struct RemoveServerItemRequest: Codable {
    public var serverId: UUID
}

public struct WaitForExistenceRequest: Codable {
    
    public var serverId: UUID
    public var timeout: TimeInterval
    
    public init(serverId: UUID, timeout: TimeInterval) {
        self.serverId = serverId
        self.timeout = timeout
    }
}

public struct WaitForExistenceResponse: Codable {
    public var elementExists: Bool
    
    public init(elementExists: Bool) {
        self.elementExists = elementExists
    }
}

public struct ElementTypeRequest: Codable {
    public let serverId: UUID
    public let elementType: Element.ElementType
    public let identifier: String?
    
    public init(serverId: UUID, elementType: Element.ElementType, identifier: String? = nil) {
        self.serverId = serverId
        self.elementType = elementType
        self.identifier = identifier
    }
}

public struct ChildrenMatchinType: Codable {
    public let serverId: UUID
    public let elementType: Element.ElementType
    
    public init(serverId: UUID, elementType: Element.ElementType) {
        self.serverId = serverId
        self.elementType = elementType
    }
}


public enum SizeClass: Int, Codable {
    case unspecified = 0
    case compact     = 1
    case regular     = 2
}
