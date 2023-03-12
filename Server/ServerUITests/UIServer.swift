import FlyingFox
import XCTest
import Foundation
import UIUnitTest

let decoder = JSONDecoder()
let encoder = JSONEncoder()

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
            } else {
                element?.tap()
            }
            
        })
        
        await addRoute("doubleTap", handler: { (tapRequest: DoubleTapRequest) in
            let element = self.findElement(matchers: tapRequest.matchers)
            element?.doubleTap()
        })
        
        await addRoute("exists", handler: { (tapRequest: ExistsRequest) in
            let element = self.findElement(matchers: tapRequest.matchers)
            let exists = element?.exists ?? false
            
            return ExistsResponse(exists: exists)
        })
        
        await addRoute("enterText", handler: { (tapRequest: EnterTextRequest) in
            let element = self.findElement(matchers: tapRequest.matchers)
            element?.typeText(tapRequest.textToEnter)
        })
        
        await addRoute("swipe", handler: { (tapRequest: SwipeRequest) in
            let element = self.findElement(matchers: tapRequest.matchers)
            
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
            let element = self.findElement(matchers: tapRequest.matchers)
            let exists = element?.waitForExistence(timeout: tapRequest.timeout) ?? false
            
            return WaitForExistenceResponse(elementExists: exists)
        })
        
        await addRoute("HomeButton", handler: { (tapRequest: HomeButtonRequest) in
            XCUIDevice.shared.press(.home)
        })
        
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
            case .tables(let identifier):
                matchedElement = matchedElement?.tables[identifier]
            case .staticText(label: let label):
                matchedElement = matchedElement?.staticTexts[label]
            case .textField(identifier: let identifier):
                matchedElement = matchedElement?.textFields[identifier]
            }
        }
        
        return matchedElement
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
