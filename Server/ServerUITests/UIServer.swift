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
        
        await addRoute("Tap", handler: { (tapRequest: TapRequest) in
            let element = self.findElement(matchers: tapRequest.matchers)
            if let duration = tapRequest.duration {
                element?.press(forDuration: duration)
            } else if let numberOfTouches = tapRequest.numberOfTouches {
                if let numberOfTaps = tapRequest.numberOfTaps {
                    element?.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
                } else {
                    element?.twoFingerTap()
                }
            } else  {
                element?.tap()
            }
            
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
        
        await addRoute("swipe", handler: { (tapRequest: SwipeRequest) in
            let element = elementIds[tapRequest.elementServerId]
            
            switch tapRequest.swipeDirection {
            case .left:
                element?.swipeLeft()
            case .right:
                element?.swipeRight()
            case .up:
                element?.swipeUp()
            case .down:
                element?.swipeDown()
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
    
    func findElement(matchers: [ElementMatcher]) -> XCUIElement? {
        var matchedElement: XCUIElement? = app
        
        for matcher in matchers {
            switch matcher {
            case .activityIndicators(let identifier):
                matchedElement = matchedElement?.activityIndicators[identifier]
            case .alerts(let identifier):
                matchedElement = matchedElement?.alerts[identifier]
            case .browsers(let identifier):
                matchedElement = matchedElement?.browsers[identifier]
            case .button(let identifier):
                matchedElement = matchedElement?.buttons[identifier]
            case .cells(let identifier):
                matchedElement = matchedElement?.cells[identifier]
            case .checkBoxes(identifier: let identifier):
                matchedElement = matchedElement?.checkBoxes[identifier]
            case .collectionViews(identifier: let identifier):
                matchedElement = matchedElement?.collectionViews[identifier]
            case .colorWells(identifier: let identifier):
                matchedElement = matchedElement?.colorWells[identifier]
            case .comboBoxes(identifier: let identifier):
                matchedElement = matchedElement?.comboBoxes[identifier]
            case .datePickers(let identifier):
                matchedElement = matchedElement?.datePickers[identifier]
            case .decrementArrows(identifier: let identifier):
                matchedElement = matchedElement?.decrementArrows[identifier]
            case .dialogs(identifier: let identifier):
                matchedElement = matchedElement?.dialogs[identifier]
            case .disclosureTriangles(identifier: let identifier):
                matchedElement = matchedElement?.disclosureTriangles[identifier]
            case .disclosedChildRows(identifier: let identifier):
                matchedElement = matchedElement?.disclosedChildRows[identifier]
            case .dockItems(identifier: let identifier):
                matchedElement = matchedElement?.dockItems[identifier]
            case .drawers(identifier: let identifier):
                matchedElement = matchedElement?.drawers[identifier]
            case .grids(identifier: let identifier):
                matchedElement = matchedElement?.grids[identifier]
            case .groups(identifier: let identifier):
                matchedElement = matchedElement?.groups[identifier]
            case .handles(identifier: let identifier):
                matchedElement = matchedElement?.handles[identifier]
            case .helpTags(identifier: let identifier):
                matchedElement = matchedElement?.helpTags[identifier]
            case .icons(identifier: let identifier):
                matchedElement = matchedElement?.icons[identifier]
            case .images(let identifier):
                matchedElement = matchedElement?.images[identifier]
            case .incrementArrows(identifier: let identifier):
                matchedElement = matchedElement?.incrementArrows[identifier]
            case .keyboards(identifier: let identifier):
                matchedElement = matchedElement?.keyboards[identifier]
            case .keys(identifier: let identifier):
                matchedElement = matchedElement?.keys[identifier]
            case .layoutAreas(identifier: let identifier):
                matchedElement = matchedElement?.layoutAreas[identifier]
            case .layoutItems(identifier: let identifier):
                matchedElement = matchedElement?.layoutItems[identifier]
            case .levelIndicators(identifier: let identifier):
                matchedElement = matchedElement?.levelIndicators[identifier]
            case .links(identifier: let identifier):
                matchedElement = matchedElement?.links[identifier]
            case .maps(identifier: let identifier):
                matchedElement = matchedElement?.maps[identifier]
            case .mattes(identifier: let identifier):
                matchedElement = matchedElement?.mattes[identifier]
            case .menuBarItems(identifier: let identifier):
                matchedElement = matchedElement?.menuBarItems[identifier]
            case .menuBars(identifier: let identifier):
                matchedElement = matchedElement?.menuBars[identifier]
            case .menuButtons(identifier: let identifier):
                matchedElement = matchedElement?.menuButtons[identifier]
            case .menuItems(identifier: let identifier):
                matchedElement = matchedElement?.menuItems[identifier]
            case .menus(identifier: let identifier):
                matchedElement = matchedElement?.menus[identifier]
            case .navigationBars(identifier: let identifier):
                matchedElement = matchedElement?.navigationBars[identifier]
            case .otherElements(identifier: let identifier):
                matchedElement = matchedElement?.otherElements[identifier]
            case .outlineRows(identifier: let identifier):
                matchedElement = matchedElement?.outlineRows[identifier]
            case .outlines(identifier: let identifier):
                matchedElement = matchedElement?.outlines[identifier]
            case .pageIndicators(identifier: let identifier):
                matchedElement = matchedElement?.pageIndicators[identifier]
            case .pickerWheels(identifier: let identifier):
                matchedElement = matchedElement?.pickerWheels[identifier]
            case .pickers(identifier: let identifier):
                matchedElement = matchedElement?.pickers[identifier]
            case .popUpButtons(identifier: let identifier):
                matchedElement = matchedElement?.popUpButtons[identifier]
            case .popovers(identifier: let identifier):
                matchedElement = matchedElement?.popovers[identifier]
            case .progressIndicators(identifier: let identifier):
                matchedElement = matchedElement?.progressIndicators[identifier]
            case .radioButtons(identifier: let identifier):
                matchedElement = matchedElement?.radioButtons[identifier]
            case .radioGroups(identifier: let identifier):
                matchedElement = matchedElement?.radioGroups[identifier]
            case .ratingIndicators(identifier: let identifier):
                matchedElement = matchedElement?.ratingIndicators[identifier]
            case .relevanceIndicators(identifier: let identifier):
                matchedElement = matchedElement?.relevanceIndicators[identifier]
            case .rulerMarkers(identifier: let identifier):
                matchedElement = matchedElement?.rulerMarkers[identifier]
            case .rulers(identifier: let identifier):
                matchedElement = matchedElement?.rulers[identifier]
            case .scrollBars(identifier: let identifier):
                matchedElement = matchedElement?.scrollBars[identifier]
            case .scrollViews(identifier: let identifier):
                matchedElement = matchedElement?.scrollViews[identifier]
            case .searchFields(identifier: let identifier):
                matchedElement = matchedElement?.searchFields[identifier]
            case .secureTextFields(identifier: let identifier):
                matchedElement = matchedElement?.secureTextFields[identifier]
            case .segmentedControls(identifier: let identifier):
                matchedElement = matchedElement?.segmentedControls[identifier]
            case .sheets(identifier: let identifier):
                matchedElement = matchedElement?.sheets[identifier]
            case .sliders(identifier: let identifier):
                matchedElement = matchedElement?.sliders[identifier]
            case .splitGroups(identifier: let identifier):
                matchedElement = matchedElement?.splitGroups[identifier]
            case .splitters(identifier: let identifier):
                matchedElement = matchedElement?.splitters[identifier]
            case .staticText(label: let label):
                matchedElement = matchedElement?.staticTexts[label]
            case .statusBars(identifier: let identifier):
                matchedElement = matchedElement?.statusBars[identifier]
            case .statusItems(identifier: let identifier):
                matchedElement = matchedElement?.statusItems[identifier]
            case .steppers(identifier: let identifier):
                matchedElement = matchedElement?.steppers[identifier]
            case .switches(identifier: let identifier):
                matchedElement = matchedElement?.switches[identifier]
            case .tabBars(identifier: let identifier):
                matchedElement = matchedElement?.tabBars[identifier]
            case .tabGroups(identifier: let identifier):
                matchedElement = matchedElement?.tabGroups[identifier]
            case .tables(let identifier):
                matchedElement = matchedElement?.tables[identifier]
            case .tableColumns(identifier: let identifier):
                matchedElement = matchedElement?.tableColumns[identifier]
            case .tableRows(identifier: let identifier):
                matchedElement = matchedElement?.tableRows[identifier]
            case .textField(identifier: let identifier):
                matchedElement = matchedElement?.textFields[identifier]
            case .textViews(identifier: let identifier):
                matchedElement = matchedElement?.textViews[identifier]
            case .timelines(identifier: let identifier):
                matchedElement = matchedElement?.timelines[identifier]
            case .toggles(identifier: let identifier):
                matchedElement = matchedElement?.toggles[identifier]
            case .toolbarButtons(identifier: let identifier):
                matchedElement = matchedElement?.toolbarButtons[identifier]
            case .toolbars(identifier: let identifier):
                matchedElement = matchedElement?.toolbars[identifier]
            case .touchBars(identifier: let identifier):
                matchedElement = matchedElement?.touchBars[identifier]
            case .valueIndicators(identifier: let identifier):
                matchedElement = matchedElement?.valueIndicators[identifier]
            case .webViews(identifier: let identifier):
                matchedElement = matchedElement?.webViews[identifier]
            case .windows(identifier: let identifier):
                matchedElement = matchedElement?.windows[identifier]
            }
        }
        
        return matchedElement
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
