import FlyingFox
import XCTest
import Foundation
import UIUnitTest

let decoder = JSONDecoder()
let encoder = JSONEncoder()

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


class UIServer {
    var app: XCUIApplication!
    
    var lastIssue: XCTIssue?
    
    var server: HTTPServer!
    
    let cache = Cache()
    
    func start() async throws {
        let server = HTTPServer(address: .loopback(port: 22087))
        self.server = server
        
        await addRoute("Activate", handler: { (activateRequest: ActivateRequest) in
            if self.app == nil {
                self.app = XCUIApplication(bundleIdentifier: activateRequest.appId)
            }
            self.app.activate()
        })
        
        
        
        await addRoute("firstMatch", handler: { (firstMatchRequest: FirstMatchRequest) in
            let query = await self.cache.getQuery(firstMatchRequest.queryRoot)
            let element = query?.firstMatch
            
            let id = await self.cache.add(element: element)
            
            return FirstMatchResponse(elementServerId: id)
        })
        
        await addRoute("elementFromQuery", handler: { (elementFromQuery: ElementFromQuery) in
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
        })
        
        await addRoute("elementMatchingPredicate", handler: { (predicateRequest: PredicateRequest) in
            let query = await self.cache.getQuery(predicateRequest.serverId) as! XCUIElementQuery
            let element = query.element(matching: predicateRequest.predicate)
            
            let id = await self.cache.add(element: element)
            
            return ElementResponse(serverId: id)
        })
        
        await addRoute("matchingPredicate", handler: { (predicateRequest: PredicateRequest) in
            let query = await self.cache.getQuery(predicateRequest.serverId) as! XCUIElementQuery
            let matching = query.matching(predicateRequest.predicate)
            let id = await self.cache.add(query: matching)
            return QueryResponse(serverId: id)
        })
        
        await addRoute("tapElement", handler: { (tapRequest: TapElementRequest) -> Bool in
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
            
        })
        
        await addRoute("doubleTap", handler: { (tapRequest: DoubleTapRequest) in
            let element = await self.cache.getElement(tapRequest.elementServerId)
            element?.doubleTap()
        })
        
        await addRoute("exists", handler: { (tapRequest: ExistsRequest) in
            let element = await self.cache.getElement(tapRequest.elementServerId)
            let exists = element?.exists ?? false
            
            return ExistsResponse(exists: exists)
        })
        
        await addRoute("enterText", handler: { (tapRequest: EnterTextRequest) in
            let element = await self.cache.getElement(tapRequest.elementServerId)
            element?.typeText(tapRequest.textToEnter)
        })
        
        await addRoute("scroll", handler: { (tapRequest: ScrollRequest) in
            let element = await self.cache.getElement(tapRequest.elementServerId)
            element?.scroll(byDeltaX: tapRequest.deltaX, deltaY: tapRequest.deltaY)
        })
        
        await addRoute("swipe", handler: { (tapRequest: SwipeRequest) in
            let element = await self.cache.getElement(tapRequest.elementServerId)
            
            let velocity = tapRequest.velocity.rawValue
            
            switch tapRequest.swipeDirection {
            case .left:
                element?.swipeLeft(velocity: XCUIGestureVelocity(velocity))
            case .right:
                element?.swipeRight(velocity: XCUIGestureVelocity(velocity))
            case .up:
                element?.swipeUp(velocity: XCUIGestureVelocity(velocity))
            case .down:
                element?.swipeDown(velocity: XCUIGestureVelocity(velocity))
            }
        })
        
        await addRoute("pinch", handler: { (pinchRequest: PinchRequest) in
            let element = await self.cache.getElement(pinchRequest.elementServerId)
            element?.pinch(withScale: pinchRequest.scale, velocity: pinchRequest.velocity)
        })
        
        await addRoute("rotate", handler: { (rotateRequest: RotateRequest) in
            let element = await self.cache.getElement(rotateRequest.elementServerId)
            element?.rotate(rotateRequest.rotation, withVelocity: rotateRequest.velocity)
        })
        
        await addRoute("waitForExistence", handler: { (tapRequest: WaitForExistenceRequest) in
            let element = await self.cache.getElement(tapRequest.elementServerId)
            let exists = element?.waitForExistence(timeout: tapRequest.timeout) ?? false
            
            return WaitForExistenceResponse(elementExists: exists)
        })
        
        await addRoute("HomeButton", handler: { (tapRequest: HomeButtonRequest) in
            XCUIDevice.shared.press(.home)
        })
        
        await addRoute("isHittable", handler: { (isHittableRequest: IsHittableRequest) in
            let isHittable = await self.cache.getElement(isHittableRequest.elementServerId)?.isHittable
            return IsHittableResponse(isHittable: isHittable ?? false)
        })
        
        await addRoute("count", handler: { (countRequest: CountRequest) in
            let count: Int = (await self.cache.getQuery(countRequest.serverId) as? XCUIElementQuery)?.count ?? -1
            return CountResponse(count: count)
        })
        
        await addRoute("queryDescendants", handler: { (countRequest: DescendantsFromQuery) in
            let rootQuery = await self.cache.getQuery(countRequest.serverId) as! XCUIElementQuery
            let descendantsQuery = rootQuery.descendants(matching: countRequest.elementType.toXCUIElementType())
            
            let id = await self.cache.add(query: descendantsQuery)
            
            return QueryResponse(serverId: id)
        })
        
        
        await addRoute("elementDescendants", handler: { (countRequest: ElementTypeRequest) in
            let rootElement = await self.cache.getElement(countRequest.serverId)!
            let descendantsQuery = rootElement.descendants(matching: countRequest.elementType.toXCUIElementType())
            
            let id = await self.cache.add(query: descendantsQuery)
            
            return QueryResponse(serverId: id)
        })
        
        await addRoute("matchingElementType", handler: { (countRequest: ElementTypeRequest) in
            let rootQuery = await self.cache.getQuery(countRequest.serverId) as! XCUIElementQuery
            let descendantsQuery = rootQuery.matching(countRequest.elementType.toXCUIElementType(), identifier: countRequest.identifier)
            let id = await self.cache.add(query: descendantsQuery)
            return QueryResponse(serverId: id)
        })
        
        await addRoute("allElementsBoundByAccessibilityElement", handler: { (countRequest: ElementsByAccessibility) in
            let rootQuery = await self.cache.getQuery(countRequest.serverId) as! XCUIElementQuery
            let allElements = rootQuery.allElementsBoundByAccessibilityElement
            
            var ids = [UUID]()
            for element in allElements {
                let id = await self.cache.add(element: element)
                ids.append(id)
            }
            
            return ElementArrayResponse(serversId: ids)
        })
        
        await addRoute("allElementsBoundByIndex", handler: { (countRequest: ElementsByAccessibility) in
            let rootQuery = await self.cache.getQuery(countRequest.serverId) as! XCUIElementQuery
            let allElements = rootQuery.allElementsBoundByIndex
            
            var ids = [UUID]()
            for element in allElements {
                let id = await self.cache.add(element: element)
                ids.append(id)
            }
            
            return ElementArrayResponse(serversId: ids)
        })
        
        await addRoute("children", handler: { (countRequest: ChildrenMatchinType) in
            var childrenQuery: XCUIElementQuery!
            
            if let rootQuery = await self.cache.getQuery(countRequest.serverId) as? XCUIElementQuery {
                childrenQuery = rootQuery.children(matching: countRequest.elementType.toXCUIElementType())
            } else if let rootElement = await self.cache.getQuery(countRequest.serverId) as? XCUIElement {
                childrenQuery = rootElement.children(matching: countRequest.elementType.toXCUIElementType())
            }
            
            let id = await self.cache.add(query: childrenQuery)
            
            return QueryResponse(serverId: id)
        })
        
        
        await self.server.appendRoute(HTTPRoute(stringLiteral: "query"), handler: { request in
            defer {
                self.lastIssue = nil
            }
            
            let queryRequest = try await decoder.decode(QueryRequest.self, from: request.bodyData)
            
            let newQuery = await self.performQuery(queryRequest: queryRequest)
            
            let serverId = await self.cache.add(query: newQuery)
            
            return self.buildResponse(QueryResponse(serverId: serverId))
        })
        
        await self.server.appendRoute(HTTPRoute(stringLiteral: "element"), handler: { request in
            defer {
                self.lastIssue = nil
            }
            
            let queryRequest = try await decoder.decode(ElementRequest.self, from: request.bodyData)
            
            let newElement = try! await self.findElement(elementRequest: queryRequest)
            
            let id = await self.cache.add(element: newElement)
            
            return self.buildResponse(ElementResponse(serverId: id))
        })
        
        await self.server.appendRoute(HTTPRoute(stringLiteral: "remove"), handler: { request in
            defer {
                self.lastIssue = nil
            }
            
            let queryRequest = try await decoder.decode(RemoveServerItemRequest.self, from: request.bodyData)
            
            await self.cache.removeQuery(queryRequest.queryRoot)
            await self.cache.removeElement(queryRequest.queryRoot)
            
            return self.buildResponse(true)
        })
        
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
    
    func findElement(elementRequest: ElementRequest) async throws -> XCUIElement {
        
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
