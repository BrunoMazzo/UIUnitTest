import FlyingFox
import XCTest
import Foundation
import UIUnitTest

let decoder = JSONDecoder()
let encoder = JSONEncoder()

//@Server
class UIServer {
    var app: XCUIApplication!
    
    var lastIssue: XCTIssue?
    
    var server: HTTPServer!
    
    let cache = Cache()
    
    func firstMatch(firstMatchRequest: FirstMatchRequest) async -> FirstMatchResponse {
        let query = await self.cache.getQuery(firstMatchRequest.queryRoot)
        let element = query?.firstMatch
        
        let id = await self.cache.add(element: element)
        
        return FirstMatchResponse(elementServerId: id)
    }
    
    func elementFromQuery(elementFromQuery: ElementFromQuery) async -> ElementResponse {
        let query = await self.cache.getQuery(elementFromQuery.serverId) as! XCUIElementQuery
        
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
    
    func elementMatchingPredicate(predicateRequest: PredicateRequest) async -> ElementResponse {
        let query = await self.cache.getQuery(predicateRequest.serverId) as! XCUIElementQuery
        let element = query.element(matching: predicateRequest.predicate)
        
        let id = await self.cache.add(element: element)
        
        return ElementResponse(serverId: id)
    }
    
    func matchingPredicate(predicateRequest: PredicateRequest) async -> QueryResponse {
        let query = await self.cache.getQuery(predicateRequest.serverId) as! XCUIElementQuery
        let matching = query.matching(predicateRequest.predicate)
        let id = await self.cache.add(query: matching)
        return QueryResponse(serverId: id)
    }
    
    func tapElement(tapRequest: TapElementRequest) async -> Bool {
        guard let element = await self.cache.getElement(tapRequest.elementServerId) else {
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
    
    func doubleTap(tapRequest: DoubleTapRequest) async -> Void {
        let element = await self.cache.getElement(tapRequest.elementServerId)
        element?.doubleTap()
    }
    
    func exists(request: ElementRequest) async -> ExistsResponse {
        let element = await self.cache.getElement(request.elementServerId)
        let exists = element?.exists ?? false
        
        return ExistsResponse(exists: exists)
    }
    
    func enterText(request: EnterTextRequest) async -> Void {
        let element = await self.cache.getElement(request.elementServerId)
        element?.typeText(request.textToEnter)
    }
    
    func value(request: ElementRequest) async -> ValueResponse {
        let element = await self.cache.getElement(request.elementServerId)
        let value = element?.value as? String
        
        return ValueResponse(value: value)
    }
    
    func scroll(request: ScrollRequest) async -> Void {
        let element = await self.cache.getElement(request.elementServerId)
        element?.scroll(byDeltaX: request.deltaX, deltaY: request.deltaY)
    }
    
    func swipe(request: SwipeRequest) async -> Void {
        let element = await self.cache.getElement(request.elementServerId)
        
        let velocity = request.velocity.rawValue
        
        switch request.swipeDirection {
        case .left:
            element?.swipeLeft(velocity: XCUIGestureVelocity(velocity))
        case .right:
            element?.swipeRight(velocity: XCUIGestureVelocity(velocity))
        case .up:
            element?.swipeUp(velocity: XCUIGestureVelocity(velocity))
        case .down:
            element?.swipeDown(velocity: XCUIGestureVelocity(velocity))
        }
    }
    
    func pinch(request: PinchRequest) async -> Void {
        let element = await self.cache.getElement(request.elementServerId)
        element?.pinch(withScale: request.scale, velocity: request.velocity)
    }
    
    func rotate(request: RotateRequest) async -> Void {
        let element = await self.cache.getElement(request.elementServerId)
        element?.rotate(request.rotation, withVelocity: request.velocity)
    }
    
    func waitForExistence(request: WaitForExistenceRequest) async -> WaitForExistenceResponse {
        let element = await self.cache.getElement(request.elementServerId)
        let exists = element?.waitForExistence(timeout: request.timeout) ?? false
        
        return WaitForExistenceResponse(elementExists: exists)
    }
    
    func isHittable(request: ElementRequest) async -> IsHittableResponse {
        let isHittable = await self.cache.getElement(request.elementServerId)?.isHittable
        return IsHittableResponse(isHittable: isHittable ?? false)
    }
    
    func count(request: CountRequest) async -> CountResponse {
        let count: Int = (await self.cache.getQuery(request.serverId) as? XCUIElementQuery)?.count ?? -1
        return CountResponse(count: count)
    }
    
    func queryDescendants(request: DescendantsFromQuery) async -> QueryResponse {
        let rootQuery = await self.cache.getQuery(request.serverId) as! XCUIElementQuery
        let descendantsQuery = rootQuery.descendants(matching: request.elementType.toXCUIElementType())
        
        let id = await self.cache.add(query: descendantsQuery)
        
        return QueryResponse(serverId: id)
    }
    
    func elementDescendants(request: ElementTypeRequest) async -> QueryResponse {
        let rootElement = await self.cache.getElement(request.serverId)!
        let descendantsQuery = rootElement.descendants(matching: request.elementType.toXCUIElementType())
        
        let id = await self.cache.add(query: descendantsQuery)
        
        return QueryResponse(serverId: id)
    }
    
    func matchingElementType(request: ElementTypeRequest) async -> QueryResponse {
        let rootQuery = await self.cache.getQuery(request.serverId) as! XCUIElementQuery
        let descendantsQuery = rootQuery.matching(request.elementType.toXCUIElementType(), identifier: request.identifier)
        let id = await self.cache.add(query: descendantsQuery)
        return QueryResponse(serverId: id)
    }
    
    func allElementsBoundByAccessibilityElement(request: ElementsByAccessibility) async -> ElementArrayResponse {
        let rootQuery = await self.cache.getQuery(request.serverId) as! XCUIElementQuery
        let allElements = rootQuery.allElementsBoundByAccessibilityElement
        
        var ids = await self.cache.add(elements: allElements)
        
        return ElementArrayResponse(serversId: ids)
    }
    
    func allElementsBoundByIndex(request: ElementsByAccessibility) async -> ElementArrayResponse {
        let rootQuery = await self.cache.getQuery(request.serverId) as! XCUIElementQuery
        let allElements = rootQuery.allElementsBoundByIndex
        
        var ids = await self.cache.add(elements: allElements)
        
        return ElementArrayResponse(serversId: ids)
    }
    
    func children(request: ChildrenMatchinType) async -> QueryResponse {
        var childrenQuery: XCUIElementQuery!
        
        if let rootQuery = await self.cache.getQuery(request.serverId) as? XCUIElementQuery {
            childrenQuery = rootQuery.children(matching: request.elementType.toXCUIElementType())
        } else if let rootElement = await self.cache.getQuery(request.serverId) as? XCUIElement {
            childrenQuery = rootElement.children(matching: request.elementType.toXCUIElementType())
        }
        
        let id = await self.cache.add(query: childrenQuery)
        
        return QueryResponse(serverId: id)
    }
    
    func element(request: ElementByIdRequest) async -> ElementResponse {
        let newElement = try! await self.findElement(elementRequest: request)
        let id = await self.cache.add(element: newElement)
        return ElementResponse(serverId: id)
    }
    
    func query(request: QueryRequest) async -> QueryResponse {
        let newQuery = await self.performQuery(queryRequest: request)
        let serverId = await self.cache.add(query: newQuery)
        return QueryResponse(serverId: serverId)
    }
    
    func remove(request: RemoveServerItemRequest) async -> Bool {
        await self.cache.removeQuery(request.queryRoot)
        await self.cache.removeElement(request.queryRoot)
        
        return true
    }
    
    func start() async throws {
        let server = HTTPServer(address: .loopback(port: 22087))
        self.server = server
        
        await addRoute("Activate", handler: { (activateRequest: ActivateRequest) in
            if self.app == nil {
                self.app = XCUIApplication(bundleIdentifier: activateRequest.appId)
            }
            self.app.activate()
        })

        await addRoute("firstMatch", handler: self.firstMatch(firstMatchRequest:))
        await addRoute("elementFromQuery", handler: self.elementFromQuery(elementFromQuery:))
        await addRoute("elementMatchingPredicate", handler: self.elementMatchingPredicate(predicateRequest:))
        await addRoute("matchingPredicate", handler: self.matchingPredicate(predicateRequest:) )
        await addRoute("tapElement", handler: self.tapElement(tapRequest:))
        await addRoute("doubleTap", handler: self.doubleTap(tapRequest:))
        await addRoute("exists", handler: self.exists(request:))
        await addRoute("value", handler: self.value(request:))
        await addRoute("enterText", handler: self.enterText(request:))
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
    
    func performQuery(queryRequest: QueryRequest) async -> XCUIElementQuery {
        var rootElementQuery: XCUIElementTypeQueryProvider = app
        if let rootQueryId = queryRequest.queryRoot, let rootQuery = await self.cache.getQuery(rootQueryId) {
            rootElementQuery = rootQuery
        }
        
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
    
    func findElement(elementRequest: ElementByIdRequest) async throws -> XCUIElement {
        
        guard let rootQueryId = elementRequest.queryRoot,
              let rootElementQuery = await self.cache.getQuery(rootQueryId) as? XCUIElementQuery else {
            throw NSError(domain: "Query not found for element \(elementRequest.identifier)", code: 1)
        }
        
        return rootElementQuery[elementRequest.identifier]
    }
    
    func addRoute<Request: Codable, Response: Codable>(_ route: String, handler: @escaping @MainActor (Request) async -> Response) async {
        await self.server.appendRoute(HTTPRoute(stringLiteral: route), handler: { request in
            
            defer {
                self.lastIssue = nil
            }
            
            let tapRequest = try await decoder.decode(Request.self, from: request.bodyData)
            
            let response = await handler(tapRequest)
            
            return self.buildResponse(response)
        })
    }
    
    func addRoute<Request: Codable>(_ route: String, handler: @escaping @MainActor (Request) async -> Void) async {
        await self.server.appendRoute(HTTPRoute(stringLiteral: route), handler: { request in
            defer {
                self.lastIssue = nil
            }
            
            let tapRequest = try await decoder.decode(Request.self, from: request.bodyData)
            await handler(tapRequest)
            
            return self.buildResponse(true)
        })
    }
}
