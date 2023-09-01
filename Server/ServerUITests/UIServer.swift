import FlyingFox
import XCTest
import Foundation
import UIUnitTest

let decoder = JSONDecoder()
let encoder = JSONEncoder()

struct ApplicationNotFoundError: Error, LocalizedError {    
    var serverId: String
    
    var errorDescription: String? {
        return "Application with id \(serverId) not found"
    }
}

struct ElementNotFoundError: Error, LocalizedError {
    var serverId: String
    
    var errorDescription: String? {
        return "Element with id \(serverId) not found"
    }
}

struct QueryNotFoundError: Error, LocalizedError {
    var serverId: String
    
    var errorDescription: String? {
        return "Query with id \(serverId) not found"
    }
}

struct CoordinateNotFoundError: Error, LocalizedError {
    var serverId: String
    
    var errorDescription: String? {
        return "Coordinate with id \(serverId) not found"
    }
}

struct WrongQueryTypeFoundError: Error, LocalizedError {
    var serverId: String
    
    var errorDescription: String? {
        return "Query with id \(serverId) is not an XCUIElementQuery"
    }
}

//@Server
class UIServer {
    var lastIssue: XCTIssue?
    
    var server: HTTPServer!
    
    let cache = Cache()
    
    @MainActor
    func firstMatch(firstMatchRequest: FirstMatchRequest) async throws -> FirstMatchResponse {
        let query = try await self.cache.getQuery(firstMatchRequest.serverId)
        let element = query.firstMatch
        
        let id = await self.cache.add(element: element)
        
        return FirstMatchResponse(serverId: id)
    }
    
    @MainActor
    func elementFromQuery(elementFromQuery: ElementFromQuery) async throws -> ElementResponse {
        let query = try await self.cache.getElementQuery(elementFromQuery.serverId)
        
        let element: XCUIElement
        if let index = elementFromQuery.index {
            element = query.element(boundBy: index)
        } else if let type = elementFromQuery.elementType {
            element = query.element(matching: type.toXCUIElementType(), identifier: elementFromQuery.identifier)
        } else {
            element = query.element
        }
        
        let id = await self.cache.add(element: element)
        
        return ElementResponse(serverId: id)
    }
    
    @MainActor
    func elementMatchingPredicate(predicateRequest: PredicateRequest) async throws -> ElementResponse {
        let query = try await self.cache.getElementQuery(predicateRequest.serverId)
        
        let element = query.element(matching: predicateRequest.predicate)
        
        let id = await self.cache.add(element: element)
        
        return ElementResponse(serverId: id)
    }
    
    @MainActor
    func matchingPredicate(predicateRequest: PredicateRequest) async throws -> QueryResponse {
        let query = try await self.cache.getElementQuery(predicateRequest.serverId)
        let matching = query.matching(predicateRequest.predicate)
        let id = await self.cache.add(query: matching)
        return QueryResponse(serverId: id)
    }
    
    @MainActor
    func matchingByIdentifier(request: ByIdRequest) async throws -> QueryResponse {
        let query = try await self.cache.getElementQuery(request.queryRoot)
        let matching = query.matching(identifier: request.identifier)
        let id = await self.cache.add(query: matching)
        return QueryResponse(serverId: id)
    }
    
    @MainActor
    func containingPredicate(request: PredicateRequest) async throws -> QueryResponse {
        let query = try await self.cache.getElementQuery(request.serverId)
        let matching = query.containing(request.predicate)
        let id = await self.cache.add(query: matching)
        return QueryResponse(serverId: id)
    }
    
    @MainActor
    func containingElementType(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootQuery = try await self.cache.getElementQuery(request.serverId)
        let query = rootQuery.containing(request.elementType.toXCUIElementType(), identifier: request.identifier)
        
        let id = await self.cache.add(query: query)
        
        return QueryResponse(serverId: id)
    }
    
    @MainActor
    func tapElement(tapRequest: TapElementRequest) async throws -> Bool {
        guard let element = try? await self.cache.getElement(tapRequest.serverId) else {
            return false
        }
        
        if let duration = tapRequest.duration {
            element.press(forDuration: duration)
        } else if let numberOfTouches = tapRequest.numberOfTouches {
            if let numberOfTaps = tapRequest.numberOfTaps {
                element.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
            } else {
                element.twoFingerTap()
            }
        } else  {
            element.tap()
        }
        
        return true
    }
    
    @MainActor
    func doubleTap(tapRequest: ElementRequest) async throws -> Void {
        let element = try await self.cache.getElement(tapRequest.serverId)
        element.doubleTap()
    }
    
    @MainActor
    func exists(request: ElementRequest) async throws -> ExistsResponse {
        let element = try await self.cache.getElement(request.serverId)
        let exists = element.exists
        
        return ExistsResponse(exists: exists)
    }
    
    @MainActor
    func typeText(request: EnterTextRequest) async throws -> Void {
        let element = try await self.cache.getElement(request.serverId)
        element.typeText(request.textToEnter)
    }
    
    @MainActor
    func value(request: ElementRequest) async throws -> ValueResponse {
        let element = try await self.cache.getElement(request.serverId)
        let value = element.value as? String
        
        return ValueResponse(value: value)
    }
    
    @MainActor
    func scroll(request: ScrollRequest) async throws -> Void {
        let element = try await self.cache.getElement(request.serverId)
        element.scroll(byDeltaX: request.deltaX, deltaY: request.deltaY)
    }
    
    @MainActor
    func swipe(request: SwipeRequest) async throws -> Void {
        let element = try await self.cache.getElement(request.serverId)
        
        let velocity = request.velocity.xcUIGestureVelocity
        
        switch request.swipeDirection {
        case .left:
            element.swipeLeft(velocity: velocity)
        case .right:
            element.swipeRight(velocity: velocity)
        case .up:
            element.swipeUp(velocity: velocity)
        case .down:
            element.swipeDown(velocity: velocity)
        }
    }
    
    @MainActor
    func pinch(request: PinchRequest) async throws -> Void {
        let element = try await self.cache.getElement(request.serverId)
        element.pinch(withScale: request.scale, velocity: request.velocity)
    }
    
    @MainActor
    func rotate(request: RotateRequest) async throws -> Void {
        let element = try await self.cache.getElement(request.serverId)
        element.rotate(request.rotation, withVelocity: request.velocity)
    }
    
    @MainActor
    func waitForExistence(request: WaitForExistenceRequest) async throws -> WaitForExistenceResponse {
        let element = try await self.cache.getElement(request.serverId)
        let exists = element.waitForExistence(timeout: request.timeout)
        
        return WaitForExistenceResponse(elementExists: exists)
    }
    
    @MainActor
    func isHittable(request: ElementRequest) async throws -> IsHittableResponse {
        let isHittable = try await self.cache.getElement(request.serverId).isHittable
        return IsHittableResponse(isHittable: isHittable)
    }
    
    @MainActor
    func count(request: CountRequest) async throws -> CountResponse {
        let count: Int = (try await self.cache.getElementQuery(request.serverId)).count
        return CountResponse(count: count)
    }
    
    @MainActor
    func queryDescendants(request: DescendantsFromQuery) async throws -> QueryResponse {
        let rootQuery = try await self.cache.getElementQuery(request.serverId)
        let descendantsQuery = rootQuery.descendants(matching: request.elementType.toXCUIElementType())
        
        let id = await self.cache.add(query: descendantsQuery)
        
        return QueryResponse(serverId: id)
    }
    
    @MainActor
    func elementDescendants(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootElement = try await self.cache.getElement(request.serverId)
        let descendantsQuery = rootElement.descendants(matching: request.elementType.toXCUIElementType())
        
        let id = await self.cache.add(query: descendantsQuery)
        
        return QueryResponse(serverId: id)
    }
    
    @MainActor
    func matchingElementType(request: ElementTypeRequest) async throws -> QueryResponse {
        let rootQuery = try await self.cache.getElementQuery(request.serverId)
        let descendantsQuery = rootQuery.matching(request.elementType.toXCUIElementType(), identifier: request.identifier)
        let id = await self.cache.add(query: descendantsQuery)
        return QueryResponse(serverId: id)
    }
    
    @MainActor
    func allElementsBoundByAccessibilityElement(request: ElementsByAccessibility) async throws -> ElementArrayResponse {
        let rootQuery = try await self.cache.getElementQuery(request.serverId)
        let allElements = rootQuery.allElementsBoundByAccessibilityElement
        
        let ids = await self.cache.add(elements: allElements)
        
        return ElementArrayResponse(serversId: ids)
    }
    
    @MainActor
    func allElementsBoundByIndex(request: ElementsByAccessibility) async throws -> ElementArrayResponse {
        let rootQuery = try await self.cache.getElementQuery(request.serverId)
        let allElements = rootQuery.allElementsBoundByIndex
        
        let ids = await self.cache.add(elements: allElements)
        
        return ElementArrayResponse(serversId: ids)
    }
    
    @MainActor
    func children(request: ChildrenMatchinType) async throws -> QueryResponse {
        var childrenQuery: XCUIElementQuery
        
        if let rootQuery = try? await self.cache.getElementQuery(request.serverId) {
            childrenQuery = rootQuery.children(matching: request.elementType.toXCUIElementType())
        } else if let rootElement = try? await self.cache.getElement(request.serverId) {
            childrenQuery = rootElement.children(matching: request.elementType.toXCUIElementType())
        } else {
            throw ElementNotFoundError(serverId: request.serverId.uuidString)
        }
        
        let id = await self.cache.add(query: childrenQuery)
        
        return QueryResponse(serverId: id)
    }
    
    @MainActor
    func element(request: ByIdRequest) async -> ElementResponse {
        let newElement = try! await self.findElement(elementRequest: request)
        let id = await self.cache.add(element: newElement)
        return ElementResponse(serverId: id)
    }
    
    @MainActor
    func query(request: QueryRequest) async throws -> QueryResponse {
        let newQuery = try await self.performQuery(queryRequest: request)
        let serverId = await self.cache.add(query: newQuery)
        return QueryResponse(serverId: serverId)
    }
    
    @MainActor
    func remove(request: RemoveServerItemRequest) async -> Bool {
        await self.cache.remove(request.serverId)
        
        return true
    }
    
    @MainActor
    func debugDescription(request: ElementRequest) async throws -> String {
        var debugDescription: String!
        
        if let rootQuery = try? await self.cache.getElementQuery(request.serverId) {
            debugDescription = rootQuery.debugDescription
        } else if let rootElement = try? await self.cache.getElement(request.serverId) {
            debugDescription = rootElement.debugDescription
        } else {
            throw ElementNotFoundError(serverId: request.serverId.uuidString)
        }
        
        return debugDescription
    }
    
    @MainActor
    func identifier(request: ElementRequest) async throws -> String {
        let rootElement = try await self.cache.getElement(request.serverId)
        return rootElement.identifier
    }
    
    @MainActor
    func title(request: ElementRequest) async throws -> String {
        let rootElement = try await self.cache.getElement(request.serverId)
        return rootElement.title
    }
    
    @MainActor
    func label(request: ElementRequest) async throws -> String {
        let rootElement = try await self.cache.getElement(request.serverId)
        return rootElement.label
    }
    
    @MainActor
    func placeholderValue(request: ElementRequest) async throws -> String? {
        let rootElement = try await self.cache.getElement(request.serverId)
        return rootElement.placeholderValue
    }
    
    @MainActor
    func isSelected(request: ElementRequest) async throws -> Bool {
        let rootElement = try await self.cache.getElement(request.serverId)
        return rootElement.isSelected
    }
    
    @MainActor
    func hasFocus(request: ElementRequest) async throws -> Bool {
        let rootElement = try await self.cache.getElement(request.serverId)
        return rootElement.hasFocus
    }
    
    @MainActor
    func isEnabled(request: ElementRequest) async throws -> Bool {
        let rootElement = try await self.cache.getElement(request.serverId)
        return rootElement.isEnabled
    }
    
    @MainActor
    func coordinate(request: CoordinateRequest) async throws -> CoordinateResponse {
        //withNormalizedOffset: CGVector
        let rootElement = try await self.cache.getElement(request.serverId)
        let coordinate = rootElement.coordinate(withNormalizedOffset: request.normalizedOffset)
        
        let coordinateUUID = await cache.add(coordinate: coordinate)
        let elementUUID = await cache.add(element: coordinate.referencedElement)
        
        return CoordinateResponse(coordinateId: coordinateUUID, referencedElementId: elementUUID, screenPoint: coordinate.screenPoint)
    }
    
    @MainActor
    func coordinateWithOffset(request: CoordinateOffsetRequest) async throws -> CoordinateResponse {
        let rootCoordinate = try await self.cache.getCoordinate(request.coordinatorId)
        let coordinate = rootCoordinate.withOffset(request.vector)
        
        let coordinateUUID = await cache.add(coordinate: coordinate)
        let elementUUID = await cache.add(element: coordinate.referencedElement)
        
        return CoordinateResponse(coordinateId: coordinateUUID, referencedElementId: elementUUID, screenPoint: coordinate.screenPoint)
    }
    
    @MainActor
    func coordinateTap(request: TapCoordinateRequest) async throws -> Bool {
        let rootCoordinate = try await self.cache.getCoordinate(request.serverId)
        
        switch request.type {
        case .tap:
            rootCoordinate.tap()
        case .doubleTap:
            rootCoordinate.doubleTap()
        case .press(forDuration: let duration):
            rootCoordinate.press(forDuration: duration)
        case .pressAndDrag(forDuration: let duration, thenDragTo: let coordinate):
            let coordinate = try await self.cache.getCoordinate(coordinate)
            rootCoordinate.press(forDuration: duration, thenDragTo: coordinate)
        case .pressDragAndHold(forDuration: let duration, thenDragTo: let coordinate, withVelocity: let velocity, thenHoldForDuration: let holdDuration):
            let coordinate = try await self.cache.getCoordinate(coordinate)
            rootCoordinate.press(forDuration: duration, thenDragTo: coordinate, withVelocity: velocity.xcUIGestureVelocity, thenHoldForDuration: holdDuration)
        }
        
        return true
    }
    
    @MainActor
    func frame(request: ElementRequest) async throws -> CGRect {
        let element = try await self.cache.getElement(request.serverId)
        return element.frame
    }
    
    @MainActor
    func horizontalSizeClass(request: ElementRequest) async throws -> SizeClass {
        let element = try await self.cache.getElement(request.serverId)
        return SizeClass(rawValue: element.horizontalSizeClass.rawValue)!
    }
    
    @MainActor
    func verticalSizeClass(request: ElementRequest) async throws -> SizeClass {
        let element = try await self.cache.getElement(request.serverId)
        return SizeClass(rawValue: element.verticalSizeClass.rawValue)!
    }
    
    @MainActor
    func elementType(request: ElementRequest) async throws -> Element.ElementType {
        let element = try await self.cache.getElement(request.serverId)
        return Element.ElementType(rawValue: element.elementType.rawValue)!
    }
    
    func start() async throws {
        let server = HTTPServer(address: .loopback(port: 22087))
        self.server = server
        
        await addRoute("createApp", handler: { (request: CreateApplicationRequest) in
            let app = XCUIApplication(bundleIdentifier: request.appId)
            await self.cache.add(application: app, id: request.serverId)
            
            if request.activate {
                app.activate()
            }
        })
        
        await addRoute("Activate", handler: { (activateRequest: ActivateRequest) in
            let app = try await self.cache.getApplication(activateRequest.serverId)
            app.activate()
        })
        
        await addRoute("firstMatch", handler: self.firstMatch(firstMatchRequest:))
        await addRoute("elementFromQuery", handler: self.elementFromQuery(elementFromQuery:))
        await addRoute("elementMatchingPredicate", handler: self.elementMatchingPredicate(predicateRequest:))
        await addRoute("matchingPredicate", handler: self.matchingPredicate(predicateRequest:))
        await addRoute("matchingByIdentifier", handler: self.matchingByIdentifier(request:))
        await addRoute("containingPredicate", handler: self.containingPredicate(request:))
        await addRoute("containingElementType", handler: self.containingElementType(request:))
        await addRoute("tapElement", handler: self.tapElement(tapRequest:))
        await addRoute("doubleTap", handler: self.doubleTap(tapRequest:))
        await addRoute("exists", handler: self.exists(request:))
        await addRoute("value", handler: self.value(request:))
        await addRoute("typeText", handler: self.typeText(request:))
        await addRoute("scroll", handler: self.scroll(request:))
        await addRoute("swipe", handler: self.swipe(request:))
        await addRoute("pinch", handler: self.pinch(request:))
        await addRoute("rotate", handler: self.rotate(request:))
        await addRoute("waitForExistence", handler: self.waitForExistence(request:))
        
        await addRoute("HomeButton", handler: { (tapRequest: HomeButtonRequest) in
            XCUIDevice.shared.press(.home)
        })
        
        await addRoute("isHittable", handler: self.isHittable(request:))
        await addRoute("count", handler: self.count(request:))
        await addRoute("queryDescendants", handler: self.queryDescendants(request:))
        await addRoute("elementDescendants", handler: self.elementDescendants(request:))
        await addRoute("matchingElementType", handler: self.matchingElementType(request:))
        await addRoute("allElementsBoundByAccessibilityElement", handler: self.allElementsBoundByAccessibilityElement(request:))
        await addRoute("allElementsBoundByIndex", handler: self.allElementsBoundByIndex(request:))
        await addRoute("children", handler: self.children(request:))
        await addRoute("query", handler: self.query(request:))
        await addRoute("element", handler: self.element(request:))
        await addRoute("remove", handler: self.remove(request:))
        await addRoute("debugDescription", handler: self.debugDescription(request:))
        
        await addRoute("identifier", handler: self.identifier(request:))
        await addRoute("title", handler: self.title(request:))
        await addRoute("label", handler: self.label(request:))
        await addRoute("placeholderValue", handler: self.placeholderValue(request:))
        await addRoute("isSelected", handler: self.isSelected(request:))
        await addRoute("hasFocus", handler: self.hasFocus(request:))
        await addRoute("isEnabled", handler: self.isEnabled(request:))
        
        await addRoute("coordinate", handler: self.coordinate(request:))
        await addRoute("coordinateWithOffset", handler: self.coordinateWithOffset(request:))
        await addRoute("coordinateTap", handler: self.coordinateTap(request:))
        
        await addRoute("frame", handler: self.frame(request:))
        await addRoute("horizontalSizeClass", handler: self.horizontalSizeClass(request:))
        await addRoute("verticalSizeClass", handler: self.verticalSizeClass(request:))
        await addRoute("elementType", handler: self.elementType(request:))
        
        await self.server.appendRoute(HTTPRoute(stringLiteral: "stop"), to: ClosureHTTPHandler({ request in
            Task {
                await self.server.stop(timeout: 10)
            }
            
            return self.buildResponse(true)
        }))
        
        let task = Task { try await server.start() }
        
        try await server.waitUntilListening()
        
        print("Server ready")
        
        _ = await task.result
    }
    
    func buildResponse(_ data: some Codable) -> HTTPResponse {
        if let lastIssue {
            return buildError(lastIssue.detailedDescription ?? lastIssue.description)
        } else {
            return HTTPResponse(statusCode: .ok, body: try! encoder.encode(UIResponse(response: data)))
        }
    }
    
    func buildError(_ error: String) -> HTTPResponse {
        return HTTPResponse(statusCode: .badRequest, body: try! encoder.encode(UIResponse<Bool>(error: error)))
    }
    
    @MainActor
    func performQuery(queryRequest: QueryRequest) async throws -> XCUIElementQuery {
        let rootElementQuery = try await self.cache.getQuery(queryRequest.serverId)
        
        let resultQuery: XCUIElementQuery
        switch queryRequest.queryType {
        case .staticTexts:
            resultQuery = rootElementQuery.staticTexts
        case .activityIndicators:
            resultQuery = rootElementQuery.activityIndicators
        case .alerts:
            resultQuery = rootElementQuery.alerts
        case .browsers:
            resultQuery = rootElementQuery.browsers
        case .buttons:
            resultQuery = rootElementQuery.buttons
        case .cells:
            resultQuery = rootElementQuery.cells
        case .checkBoxes:
            resultQuery = rootElementQuery.staticTexts
        case .collectionViews:
            resultQuery = rootElementQuery.collectionViews
        case .colorWells:
            resultQuery = rootElementQuery.colorWells
        case .comboBoxes:
            resultQuery = rootElementQuery.comboBoxes
        case .datePickers:
            resultQuery = rootElementQuery.datePickers
        case .decrementArrows:
            resultQuery = rootElementQuery.decrementArrows
        case .dialogs:
            resultQuery = rootElementQuery.dialogs
        case .disclosureTriangles:
            resultQuery = rootElementQuery.disclosureTriangles
        case .disclosedChildRows:
            resultQuery = rootElementQuery.disclosedChildRows
        case .dockItems:
            resultQuery = rootElementQuery.dockItems
        case .drawers:
            resultQuery = rootElementQuery.drawers
        case .grids:
            resultQuery = rootElementQuery.grids
        case .groups:
            resultQuery = rootElementQuery.groups
        case .handles:
            resultQuery = rootElementQuery.handles
        case .helpTags:
            resultQuery = rootElementQuery.helpTags
        case .icons:
            resultQuery = rootElementQuery.icons
        case .images:
            resultQuery = rootElementQuery.images
        case .incrementArrows:
            resultQuery = rootElementQuery.incrementArrows
        case .keyboards:
            resultQuery = rootElementQuery.keyboards
        case .keys:
            resultQuery = rootElementQuery.keys
        case .layoutAreas:
            resultQuery = rootElementQuery.layoutAreas
        case .layoutItems:
            resultQuery = rootElementQuery.layoutItems
        case .levelIndicators:
            resultQuery = rootElementQuery.levelIndicators
        case .links:
            resultQuery = rootElementQuery.links
        case .maps:
            resultQuery = rootElementQuery.maps
        case .mattes:
            resultQuery = rootElementQuery.mattes
        case .menuBarItems:
            resultQuery = rootElementQuery.menuBarItems
        case .menuBars:
            resultQuery = rootElementQuery.menuBars
        case .menuButtons:
            resultQuery = rootElementQuery.menuButtons
        case .menuItems:
            resultQuery = rootElementQuery.menuItems
        case .menus:
            resultQuery = rootElementQuery.menus
        case .navigationBars:
            resultQuery = rootElementQuery.navigationBars
        case .otherElements:
            resultQuery = rootElementQuery.otherElements
        case .outlineRows:
            resultQuery = rootElementQuery.outlineRows
        case .outlines:
            resultQuery = rootElementQuery.outlines
        case .pageIndicators:
            resultQuery = rootElementQuery.pageIndicators
        case .pickerWheels:
            resultQuery = rootElementQuery.pickerWheels
        case .pickers:
            resultQuery = rootElementQuery.pickers
        case .popUpButtons:
            resultQuery = rootElementQuery.popUpButtons
        case .popovers:
            resultQuery = rootElementQuery.popovers
        case .progressIndicators:
            resultQuery = rootElementQuery.progressIndicators
        case .radioButtons:
            resultQuery = rootElementQuery.radioButtons
        case .radioGroups:
            resultQuery = rootElementQuery.radioGroups
        case .ratingIndicators:
            resultQuery = rootElementQuery.ratingIndicators
        case .relevanceIndicators:
            resultQuery = rootElementQuery.relevanceIndicators
        case .rulerMarkers:
            resultQuery = rootElementQuery.rulerMarkers
        case .rulers:
            resultQuery = rootElementQuery.rulers
        case .scrollBars:
            resultQuery = rootElementQuery.scrollBars
        case .scrollViews:
            resultQuery = rootElementQuery.scrollViews
        case .searchFields:
            resultQuery = rootElementQuery.searchFields
        case .secureTextFields:
            resultQuery = rootElementQuery.secureTextFields
        case .segmentedControls:
            resultQuery = rootElementQuery.segmentedControls
        case .sheets:
            resultQuery = rootElementQuery.sheets
        case .sliders:
            resultQuery = rootElementQuery.sliders
        case .splitGroups:
            resultQuery = rootElementQuery.splitGroups
        case .splitters:
            resultQuery = rootElementQuery.splitters
        case .statusBars:
            resultQuery = rootElementQuery.statusBars
        case .statusItems:
            resultQuery = rootElementQuery.statusItems
        case .steppers:
            resultQuery = rootElementQuery.steppers
        case .switches:
            resultQuery = rootElementQuery.switches
        case .tabBars:
            resultQuery = rootElementQuery.tabBars
        case .tabGroups:
            resultQuery = rootElementQuery.tabGroups
        case .tableColumns:
            resultQuery = rootElementQuery.tableColumns
        case .tableRows:
            resultQuery = rootElementQuery.tableRows
        case .tables:
            resultQuery = rootElementQuery.tables
        case .textFields:
            resultQuery = rootElementQuery.textFields
        case .textViews:
            resultQuery = rootElementQuery.textViews
        case .timelines:
            resultQuery = rootElementQuery.timelines
        case .toggles:
            resultQuery = rootElementQuery.toggles
        case .toolbarButtons:
            resultQuery = rootElementQuery.toolbarButtons
        case .toolbars:
            resultQuery = rootElementQuery.toolbars
        case .touchBars:
            resultQuery = rootElementQuery.touchBars
        case .valueIndicators:
            resultQuery = rootElementQuery.valueIndicators
        case .webViews:
            resultQuery = rootElementQuery.webViews
        case .windows:
            resultQuery = rootElementQuery.windows
        }
        
        return resultQuery
    }
    
    func findElement(elementRequest: ByIdRequest) async throws -> XCUIElement {
        let rootElementQuery = try await self.cache.getElementQuery(elementRequest.queryRoot)
        
        return rootElementQuery[elementRequest.identifier]
    }
    
    func addRoute<Request: Codable, Response: Codable>(_ route: String, handler: @escaping @MainActor (Request) async throws -> Response) async {
        await self.server.appendRoute(HTTPRoute(stringLiteral: route), handler: { request in
            
            defer {
                self.lastIssue = nil
            }
            
            let tapRequest = try await decoder.decode(Request.self, from: request.bodyData)
            
            do {
                let response = try await handler(tapRequest)
                return self.buildResponse(response)
            } catch {
                return self.buildError(error.localizedDescription)
            }
        })
    }
    
    func addRoute<Request: Codable>(_ route: String, handler: @escaping @MainActor (Request) async throws -> Void) async {
        await self.server.appendRoute(HTTPRoute(stringLiteral: route), handler: { request in
            defer {
                self.lastIssue = nil
            }
            
            let tapRequest = try await decoder.decode(Request.self, from: request.bodyData)
            
            do {
                try await handler(tapRequest)
                return self.buildResponse(true)
            } catch {
                return self.buildError(error.localizedDescription)
            }
            
            
        })
    }
}

public extension Element.ElementType {
    func toXCUIElementType() -> XCUIElement.ElementType {
        XCUIElement.ElementType(rawValue: self.rawValue)!
    }
}

public extension GestureVelocity {
    var xcUIGestureVelocity: XCUIGestureVelocity {
        switch self {
        case .slow:
            return .slow
        case .fast:
            return .fast
        case .default:
            return .default
        case .custom(let value):
            return XCUIGestureVelocity(rawValue: value) 
        }
    }
}
