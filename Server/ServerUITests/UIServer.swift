import FlyingFox
import XCTest
import Foundation
import UIUnitTest

let decoder = JSONDecoder()
let encoder = JSONEncoder()

var queryIds: [UUID: XCUIElementTypeQueryProvider] = [:]
var elementIds: [UUID: XCUIElement] = [:]

class UIServer {
    var app: XCUIApplication!
    
    var lastIssue: XCTIssue?
    
    var server: HTTPServer!
    
    func start() async throws {
        let server = HTTPServer(address: .loopback(port: 22087))
        self.server = server
        
        await addRoute("Activate", handler: { (activateRequest: ActivateRequest) in
            if self.app == nil {
                self.app = XCUIApplication(bundleIdentifier: activateRequest.appId)
            }
            self.app.activate()
        })
        
        await addRoute("tapElement", handler: { (tapRequest: TapElementRequest) -> Bool in
            guard let element = elementIds[tapRequest.elementServerId] else {
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
            let element = elementIds[tapRequest.elementServerId]
            element?.doubleTap()
        })
        
        await addRoute("exists", handler: { (tapRequest: ExistsRequest) in
            let element = elementIds[tapRequest.elementServerId]
            let exists = element?.exists ?? false
            
            return ExistsResponse(exists: exists)
        })
        
        await addRoute("enterText", handler: { (tapRequest: EnterTextRequest) in
            let element = elementIds[tapRequest.elementServerId]
            element?.typeText(tapRequest.textToEnter)
        })
        
        await addRoute("scroll", handler: { (tapRequest: ScrollRequest) in
            let element = elementIds[tapRequest.elementServerId]
            element?.scroll(byDeltaX: tapRequest.deltaX, deltaY: tapRequest.deltaY)
        })
        
        await addRoute("swipe", handler: { (tapRequest: SwipeRequest) in
            let element = elementIds[tapRequest.elementServerId]
            
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
        
        await addRoute("waitForExistence", handler: { (tapRequest: WaitForExistenceRequest) in
            let element = elementIds[tapRequest.elementServerId]
            let exists = element?.waitForExistence(timeout: tapRequest.timeout) ?? false
            
            return WaitForExistenceResponse(elementExists: exists)
        })
        
        await addRoute("HomeButton", handler: { (tapRequest: HomeButtonRequest) in
            XCUIDevice.shared.press(.home)
        })
        
        await addRoute("isHittable", handler: { (isHittableRequest: IsHittableRequest) in
            let isHittable = elementIds[isHittableRequest.elementServerId]?.isHittable
            return IsHittableResponse(isHittable: isHittable ?? false)
        })
        
        await addRoute("count", handler: { (countRequest: CountRequest) in
            let count: Int = (queryIds[countRequest.serverId] as? XCUIElementQuery)?.count ?? -1
            return CountResponse(count: count)
        })
        
        await self.server.appendRoute(HTTPRoute(stringLiteral: "query")) { request in
            defer {
                self.lastIssue = nil
            }
            
            let queryRequest = try decoder.decode(QueryRequest.self, from: request.body)
            
            let newQuery = self.performQuery(queryRequest: queryRequest)
            
            let serverId = UUID()
            queryIds[serverId] = newQuery
            
            
            return self.buildResponse(QueryResponse(serverId: serverId))
        }
        
        await self.server.appendRoute(HTTPRoute(stringLiteral: "element")) { request in
            defer {
                self.lastIssue = nil
            }
            
            let queryRequest = try decoder.decode(ElementRequest.self, from: request.body)
            
            let newElement = try! self.findElement(elementRequest: queryRequest)
            
            let serverId = UUID()
            queryIds[serverId] = newElement
            elementIds[serverId] = newElement
            
            return self.buildResponse(ElementResponse(serverId: serverId))
        }
        
        await self.server.appendRoute(HTTPRoute(stringLiteral: "remove")) { request in
            defer {
                self.lastIssue = nil
            }
            
            let queryRequest = try decoder.decode(RemoveServerItemRequest.self, from: request.body)
            
            queryIds.removeValue(forKey: queryRequest.queryRoot)
            elementIds.removeValue(forKey: queryRequest.queryRoot)
            
            return self.buildResponse(true)
        }
        
        try await server.start()
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
    
    func performQuery(queryRequest: QueryRequest) -> XCUIElementQuery {
        var rootElementQuery: XCUIElementTypeQueryProvider = app
        if let rootQueryId = queryRequest.queryRoot, let rootQuery = queryIds[rootQueryId] {
            rootElementQuery = rootQuery
        }
        
        let resultQuery: XCUIElementQuery
        switch queryRequest.elementType {
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
    
    func findElement(elementRequest: ElementRequest) throws -> XCUIElement {
        
        guard let rootQueryId = elementRequest.queryRoot,
                let rootElementQuery = queryIds[rootQueryId] as? XCUIElementQuery else {
            throw NSError(domain: "Query not found for element \(elementRequest.identifier)", code: 1)
        }
        
        return rootElementQuery[elementRequest.identifier]
    }
    
    func addRoute<Request: Codable, Response: Codable>(_ route: String, handler: @escaping @MainActor (Request) async -> Response) async {
        await self.server.appendRoute(HTTPRoute(stringLiteral: route)) { request in
            
            defer {
                self.lastIssue = nil
            }
            
            let tapRequest = try decoder.decode(Request.self, from: request.body)
            
            let response = await handler(tapRequest)
            
            return self.buildResponse(response)
        }
    }
    
    func addRoute<Request: Codable>(_ route: String, handler: @escaping @MainActor (Request) async -> Void) async {
        await self.server.appendRoute(HTTPRoute(stringLiteral: route)) { request in
            defer {
                self.lastIssue = nil
            }

            let tapRequest = try decoder.decode(Request.self, from: request.body)
            await handler(tapRequest)
            
            return self.buildResponse(true)
        }
    }
}
