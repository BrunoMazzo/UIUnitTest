import Foundation

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
    
    public enum ElementType: Codable {
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
//
//
//    /** Whether or not a hit point can be computed for the element for the purpose of synthesizing events. */
//    open var isHittable: Bool { get }
//
//
//    /** Returns a query for all descendants of the element matching the specified type. */
//    open func descendants(matching type: Element.ElementType) -> ElementQuery
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
    
    public func tap() async throws {
        let tapElementResponse = TapElementRequest(elementServerId: self.serverId)
        
        let _: Bool = try await callServer(path: "tapElement", request: tapElementResponse)
    }
    
    public func twoFingerTap() async throws {
        let activateRequestData = TapElementRequest(elementServerId: self.serverId, numberOfTouches: 2)
        
        let _: Bool = try await callServer(path: "tapElement", request: activateRequestData)
    }
    
    public func tap(withNumberOfTaps numberOfTaps: Int, numberOfTouches: Int) async throws {
        let activateRequestData = TapElementRequest(elementServerId: self.serverId, numberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
        
        let _: Bool = try await callServer(path: "tapElement", request: activateRequestData)
    }
    
    public func press(forDuration duration: TimeInterval) async throws {
        let activateRequestData = TapElementRequest(elementServerId: self.serverId, duration: duration)
        
        let _: Bool = try await callServer(path: "tapElement", request: activateRequestData)
    }
    
    public func enterText(_ textToEnter: String) async throws {
        let activateRequestData = EnterTextRequest(elementServerId: self.serverId, textToEnter: textToEnter)
        let _: Bool = try await callServer(path: "enterText", request: activateRequestData)
    }
}

public struct TapElementRequest: Codable {
    
    public var elementServerId: UUID
    public var duration: TimeInterval?
    public var numberOfTaps: Int?
    public var numberOfTouches: Int?

    init(elementServerId: UUID, duration: TimeInterval? = nil, numberOfTaps: Int? = nil, numberOfTouches: Int? = nil) {
        self.elementServerId = elementServerId
        self.duration = duration
        self.numberOfTaps = numberOfTaps
        self.numberOfTouches = numberOfTouches
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


public struct RemoveServerItemRequest: Codable {
    public var queryRoot: UUID
}
