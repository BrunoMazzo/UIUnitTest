import Foundation
import XCTest

public class Element: ElementTypeQueryProvider {
    public var queryServerId: UUID? {
        serverId
    }
    
    var serverId: UUID
    
    init(serverId: UUID) {
        self.serverId = serverId
    }
    
    deinit {
        let serverId = serverId
        Task {
            let _: Bool = try await callServer(path: "remove", request: RemoveServerItemRequest(queryRoot: serverId))
        }
    }
    
    public var exists: Bool {
        get async throws {
            let existsRequestData = ExistsRequest(elementServerId: serverId)
            
            let existsResponse: ExistsResponse = try await callServer(path: "exists", request: existsRequestData)
            
            return existsResponse.exists
        }
    }

    /** Waits the specified amount of time for the element's exist property to be true and returns false if the timeout expires without the element coming into existence. */
    public func waitForExistence(timeout: TimeInterval) async throws -> Bool {
        let activateRequestData = WaitForExistenceRequest(elementServerId: serverId, timeout: timeout)
        
        let response: WaitForExistenceResponse = try await callServer(path: "waitForExistence", request: activateRequestData)
        
        return response.elementExists
    }


    /** Whether or not a hit point can be computed for the element for the purpose of synthesizing events. */
    open var isHittable: Bool {
        get async throws {
            let existsRequestData = IsHittableRequest(elementServerId: serverId)
            
            let existsResponse: IsHittableResponse = try await callServer(path: "isHittable", request: existsRequestData)
            
            return existsResponse.isHittable
        }
    }

    /** Returns a query for all descendants of the element matching the specified type. */
    func descendants(matching type: Element.ElementType) async throws -> Query {
        let descendantsFromElement = DescendantsFromElement(serverId: self.serverId, elementType: type)
        
        let queryResponse: QueryResponse = try await callServer(path: "elementDescendants", request: descendantsFromElement)
        
        return Query(queryServerId: queryResponse.serverId)
    }
//
//
//    /** Returns a query for direct children of the element matching the specified type. */
//    open func children(matching type: Element.ElementType) -> ElementQuery
//
//
//    /** Creates and returns a new coordinate that will compute its screen point by adding the offset multiplied by the size of the element’s frame to the origin of the element’s frame. */
//    open func coordinate(withNormalizedOffset normalizedOffset: CGVector) -> XCUICoordinate
//
//
//    /**
//     @discussion
//     Provides debugging information about the element. The data in the string will vary based on the
//     time at which it is captured, but it may include any of the following as well as additional data:
//     • Values for the elements attributes.
//     • The entire tree of descendants rooted at the element.
//     • The element's query.
//     This data should be used for debugging only - depending on any of the data as part of a test is unsupported.
//     */
//    open var debugDescription: String { get }
//}
//
    public func scroll(byDeltaX deltaX: CGFloat, deltaY: CGFloat) async throws {
        let activateRequestData = ScrollRequest(elementServerId: self.serverId, deltaX: deltaX, deltaY: deltaY)
        let _: Bool = try await callServer(path: "scroll", request: activateRequestData)
    }

    
    public func enterText(_ textToEnter: String) async throws {
        let activateRequestData = EnterTextRequest(elementServerId: self.serverId, textToEnter: textToEnter)
        let _: Bool = try await callServer(path: "enterText", request: activateRequestData)
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
        
        public func toXCUIElementType() -> XCUIElement.ElementType {
            XCUIElement.ElementType(rawValue: self.rawValue)!
        }
    }
}

public struct ScrollRequest: Codable {
    public var elementServerId: UUID
    public var deltaX: CGFloat
    public var deltaY: CGFloat
    
    init(elementServerId: UUID, deltaX: CGFloat, deltaY: CGFloat) {
        self.elementServerId = elementServerId
        self.deltaX = deltaX
        self.deltaY = deltaY
    }
}

public struct ElementRequest: Codable {
    public var queryRoot: UUID?
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
    public var queryRoot: UUID
}

public struct WaitForExistenceRequest: Codable {
    
    public var elementServerId: UUID
    public var timeout: TimeInterval
    
    public init(elementServerId: UUID, timeout: TimeInterval) {
        self.elementServerId = elementServerId
        self.timeout = timeout
    }
}

public struct WaitForExistenceResponse: Codable {
    public var elementExists: Bool
    
    public init(elementExists: Bool) {
        self.elementExists = elementExists
    }
}

public struct DescendantsFromElement: Codable {
    public let serverId: UUID
    public let elementType: Element.ElementType
    
    public init(serverId: UUID, elementType: Element.ElementType) {
        self.serverId = serverId
        self.elementType = elementType
    }
}
